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
  final username = TextEditingController();
  final password = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
                controller: username,
                decoration: InputDecoration(
                  hintText: '用户名',
                )),
            Padding(padding: EdgeInsets.all(5)),
            TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '密码',
                )),
            Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
                style: srStyle,
                child: Text('登录'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 1000),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ChatIndeterminatePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var a = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutExpo,
                                reverseCurve: Curves.easeOutExpo);
                            return FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(a),
                                child: SlideTransition(
                                    position: Tween<Offset>(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset(0.0, 0.0))
                                        .animate(a),
                                    child: child));
                          }));
                })
          ])),
    ));
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
      home: LoginScreen(),
    );
  }
}
