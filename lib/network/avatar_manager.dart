import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/network/socket.dart';

class ImageBuffer {
  BytesBuilder builder = BytesBuilder();

  void append(Uint8List data) {
    builder.add(data);
  }
}

class AvatarManager {
  static final Map<int, Image> avatars = {};
  static final Map<int, ImageBuffer> _buffers = {};

  static void load(int id, Uint8List data) {
    avatars[id] = Image.memory(data, width: 50, height: 50);
  }

  static Future<Image> request(int id) async {
    if (avatars[id] == null) {
      socketSend(RequestAvatarPacket(id: id));
    }
    while (avatars[id] == null) {
      await Future.delayed(Duration.zero);
    }
    return Future.value(avatars[id]);
  }

  static void handle(Packet packet) {
    packet as RecvAvatarPacket;
    switch (packet.type) {
      case 1:
        _buffers[packet.id] = ImageBuffer();
        break;
      case 2:
        _buffers[packet.id]!.append(packet.data);
        break;
      case 3:
        _buffers[packet.id]!.append(packet.data);
        var abc = _buffers[packet.id]!.builder.toBytes();
        load(packet.id, abc);
        _buffers.remove(packet.id);
        break;
    }
  }
}
