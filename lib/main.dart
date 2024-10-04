import 'package:flutter/material.dart';
import 'package:flutter_starrail/network/socket.dart';
import 'package:flutter_starrail/packs/starrail_button.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'chat_indeterminate_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  timeDilation = 1.5;
  await socketConnect();
  runApp(const MyApp());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: srStyle,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatIndeterminatePage()));
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter StarRail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(surface: uiSurfaceColor),
          useMaterial3: true,
          fontFamily: "StarRailFont_bundle"),
      home: const LoginScreen(),
    );
  }
}
