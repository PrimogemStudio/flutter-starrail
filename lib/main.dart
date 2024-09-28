import 'package:flutter/material.dart';
import 'chat_main_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() {
  timeDilation = 1.5;
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
        colorScheme: const ColorScheme.light(
          surface: Color.fromARGB(255, 235, 235, 235)
        ), 
        useMaterial3: true,
        fontFamily: "StarRailFont"
      ),
      home: const ChatMainPage(),
    );
  }
}