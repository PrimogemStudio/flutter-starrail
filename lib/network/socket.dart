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
  String avatar;

  LoginPacket({required this.username, required this.avatar});

  @override
  void write(Socket socket) {
    var un = utf8.encode(username);
    var av = utf8.encode(avatar);
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
    socket.write(2);
    socket.write(message);
  }
}

class RecvMessagePacket implements Packet {
  late String message;
  late String user;
  late String avatar;

  RecvMessagePacket(Uint8List data) {
    var view = data.buffer.asByteData();
    var size = view.getUint32(1, Endian.host);
    var len = view.getUint8(5);
    message = utf8.decode(data.buffer.asUint8List(6, size));
    user = utf8.decode(data.buffer.asUint8List(6 + size, len));
    avatar = utf8.decode(data.buffer.asUint8List(6 + size + len));
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
  socket = await Socket.connect("60.215.128.117", 10646);
  socket!.listen((data) {
    var buf = ByteData.view(data.buffer);
    switch (buf.getUint8(0)) {
      case 1:
        var p = RecvMessagePacket(data);
        for (var h in handlers) {
          if (h.type == RecvMessagePacket) h.callback(p);
        }
        break;
    }
  });
}

void socketSend(Packet packet) async {
  packet.write(socket!);
  await socket!.flush();
}
