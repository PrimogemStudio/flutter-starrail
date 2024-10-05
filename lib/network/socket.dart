import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Socket? socket;
List<Handler> handlers = List.empty(growable: true);
bool server = false;

abstract class Packet {
  void write(Socket socket);
}

class Handler {
  static int _id = 0;
  int id = _id++;
  Type type;
  void Function(Packet) callback;

  Handler({required this.type, required this.callback});
}

class LoginPacket implements Packet {
  String username;
  String password;

  LoginPacket({required this.username, required this.password});

  @override
  void write(Socket socket) {
    var un = utf8.encode(username);
    var av = utf8.encode(password);
    var buf = ByteData(2 + un.length + av.length);
    var byteView = buf.buffer.asUint8List();
    buf.setUint8(0, 1);
    buf.setUint8(1, un.length.toUnsigned(8));
    byteView.setAll(2, un);
    byteView.setAll(2 + un.length, av);
    socket.add(byteView);
  }
}

class SendMessagePacket implements Packet {
  String message;

  SendMessagePacket({required this.message});

  @override
  void write(Socket socket) {
    var msg = utf8.encode(message);
    var buf = ByteData(5 + msg.length);
    var byteView = buf.buffer.asUint8List();
    buf.setUint8(0, 2);
    buf.setUint32(1, msg.length.toUnsigned(32), Endian.host);
    byteView.setAll(5, msg);
    socket.add(byteView);
  }
}

class RecvMessagePacket implements Packet {
  late String message;
  late String user;
  late int avatar;

  RecvMessagePacket(Uint8List data) {
    var view = data.buffer.asByteData();
    var size = view.getUint32(1, Endian.host);
    var len = view.getUint8(5);
    message = utf8.decode(data.buffer.asUint8List(6, size));
    user = utf8.decode(data.buffer.asUint8List(6 + size, len));
    avatar = view.getUint16(6 + size + len, Endian.host);
  }

  @override
  void write(Socket socket) {
    throw UnimplementedError("unsupported");
  }
}

class RecvAvatarPacket implements Packet {
  late int id;
  late Uint8List data;

  RecvAvatarPacket(Uint8List data) {
    var view = data.buffer.asByteData();
    id = view.getUint16(1, Endian.host);
    this.data = data.buffer.asUint8List(3);
  }

  @override
  void write(Socket socket) {
    throw UnimplementedError("unsupported");
  }
}

void handlePacker(Type type, void Function(Packet) callback) {
  handlers.add(Handler(type: type, callback: callback));
}

Future<void> socketConnect() async {
  socket = await Socket.connect("127.0.0.1", 32767);
  // socket = await Socket.connect("60.215.128.117", 10646);
  socket!.listen((data) {
    var buf = ByteData.view(data.buffer);
    switch (buf.getUint8(0)) {
      case 1:
        var p = RecvMessagePacket(data);
        for (var h in handlers) {
          if (h.type == RecvMessagePacket) h.callback(p);
        }
        break;
      case 2:
        var p = RecvAvatarPacket(data);
        for (var h in handlers) {
          if (h.type == RecvAvatarPacket) h.callback(p);
        }
    }
  });
}

void socketSend(Packet packet) async {
  packet.write(socket!);
  await socket!.flush();
}
