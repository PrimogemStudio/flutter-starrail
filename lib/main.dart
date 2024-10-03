import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'chat_main_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:args/args.dart';
import 'dart:io';

Socket? socket;
ServerSocket? serverSocket;

bool server = false;

void main(List<String> arguments) async {
  timeDilation = 1.5;
  final parser = ArgParser()
    ..addFlag('server', abbr: 's', help: 'Open as server');
  final args = parser.parse(arguments);
  server = args.flag("server");
  if (server) {
    serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 32767);
    await for (var s in serverSocket!) {
      socket = s;
      break;
    }
  } else {
    // socket = await Socket.connect("60.215.128.117", 10646);
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
