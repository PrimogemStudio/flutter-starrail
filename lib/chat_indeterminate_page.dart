import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/chat_main_page.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/utils.dart';

import 'chat_header.dart';

class ChatIndeterminatePage extends StatefulWidget {
  const ChatIndeterminatePage({
    super.key
  });
  @override
  State<StatefulWidget> createState() => ChatIndeterminatePageState();
}

class ChatIndeterminatePageState extends State<ChatIndeterminatePage> {
  GlobalKey<ChatMainPageState> mainPageKey = GlobalKey();
  GlobalKey<ChatHeaderState> headerKey = GlobalKey();
  double blur = 0;
  @override
  Widget build(BuildContext context) {
    Scaffold sc = Scaffold(
        body: ChatMainPage(key: mainPageKey),
        appBar: AppBar(
            backgroundColor: uiSurfaceColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            title: ChatHeader(key: headerKey),
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent),
        floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          withPadding(FloatingActionButton(
              onPressed: () => mainPageKey.currentState!.openPanel(),
              tooltip: '添加测试信息',
              child: const Icon(Icons.add))),
          withPadding(FloatingActionButton(
              onPressed: () {
                headerKey.currentState!.updateText(() {});
              },
              tooltip: '测试 Header',
              child: const Icon(Icons.edit))),
          withPadding(FloatingActionButton(onPressed: () {
            showGeneralDialog(
              barrierColor: Colors.transparent,
              barrierDismissible: true,
              barrierLabel: "",
              context: context,
              pageBuilder:
                  (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                return AlertDialog(
                  backgroundColor: uiDialogBg,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))
                  ),
                  title: const Text("提示"),
                  content: const Text("确定删除吗？"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("取消"),
                    ),
                    TextButton(onPressed: () {}, child: const Text("确定")),
                  ],
                );
              },
              transitionDuration: const Duration(milliseconds: 200),
              transitionBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child) {
                animation.addListener(() { updateBlur(animation.value * 5); });
                return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(
                    begin: const Offset(0, 0.1), end: const Offset(0, 0))
                    .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutExpo,
                    reverseCurve: Curves.easeOutExpo)), child: child));
              },
            );
          }))
        ]));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: Stack(children: [
          sc,
          IgnorePointer(child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
                color: Colors.white.withOpacity(0.01)
            ),
          ))
        ]));
  }

  void updateBlur(double v) {
    setState(() {
      blur = v;
    });
  }
}