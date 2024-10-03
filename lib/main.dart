import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
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
          colorScheme: ColorScheme.light(
              surface: uiSurfaceColor
          ),
          useMaterial3: true,
          fontFamily: "StarRailFont_bundle"),
      home: ChatMainPage(),
    );
  }
}
