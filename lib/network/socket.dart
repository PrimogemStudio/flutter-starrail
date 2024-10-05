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

class RequestAvatarPacket implements Packet {
  int id;

  RequestAvatarPacket({required this.id});

  @override
  void write(Socket socket) {
    var buf = ByteData(3);
    var byteView = buf.buffer.asUint8List();
    buf.setUint8(0, 3);
    buf.setUint16(1, id, Endian.host);
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
  int id = 0;
  int type = 0;
  int size = 0;
  late Uint8List data;

  RecvAvatarPacket(Uint8List data) {
    var view = data.buffer.asByteData();
    id = view.getUint16(1, Endian.host);
    type = view.getUint8(3);
    if (type == 1) {
      size = view.getUint32(4, Endian.host);
      this.data = Uint8List(0);
      return;
    } else if (type == 2) {
      this.data = data.buffer.asUint8List(4, 1024);
      return;
    } else if (type == 3) {
      size = view.getUint32(4, Endian.host);
      this.data = data.buffer.asUint8List(8, size);
      return;
    }
    data = Uint8List(0);
  }

  @override
  void write(Socket socket) {
    throw UnimplementedError("unsupported");
  }
}

class LoginResultPacket implements Packet {
  late int type;
  late String message;

  LoginResultPacket(Uint8List data) {
    var view = data.buffer.asByteData();
    type = view.getUint8(1);
    message = utf8.decode(data.buffer.asUint8List(1));
  }

  @override
  void write(Socket socket) {
    throw UnimplementedError("unsupported");
  }
}

class ChoiceChannelPacket implements Packet {
  late String channel;
  late String desc;

  ChoiceChannelPacket(Uint8List data) {
    var view = data.buffer.asByteData();
    var size = view.getUint32(1, Endian.host);
    channel = utf8.decode(data.buffer.asUint8List(5, size));
    desc = utf8.decode(data.buffer.asUint8List(5 + size));
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
      case 3:
        var p = LoginResultPacket(data);
        for (var h in handlers) {
          if (h.type == LoginResultPacket) h.callback(p);
        }
      case 4:
        var p = ChoiceChannelPacket(data);
        for (var h in handlers) {
          if (h.type == ChoiceChannelPacket) h.callback(p);
        }
    }
  });
}

void socketSend(Packet packet) async {
  packet.write(socket!);
  await socket!.flush();
}
