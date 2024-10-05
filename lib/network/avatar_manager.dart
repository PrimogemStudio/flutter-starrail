import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/network/socket.dart';

class AvatarManager {
  static Map<int, Image> avatars = {};

  static void load(int id, Uint8List data) {
    avatars[id] = Image.memory(data, width: 50.0, height: 50.0);
  }

  static void handle(Packet packet) {
    packet as RecvAvatarPacket;
    load(packet.id, packet.data);
  }
}
