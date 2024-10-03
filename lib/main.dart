import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'chat_main_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:io';

Socket? socket;
ServerSocket? serverSocket;

const bool server = false;

void main() async {
  timeDilation = 1.5;
  if (server) {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 32767);
    serverSocket!.listen((s) {
      socket = s;
    });
  } else {
    socket = await Socket.connect("127.0.0.1", 32767);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(surface: uiSurfaceColor),
          useMaterial3: true,
          fontFamily: "StarRailFont_bundle"),
      home: ChatMainPage(),
    );
  }
}
