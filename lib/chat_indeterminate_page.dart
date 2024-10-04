import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/chat_main_page.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_dialog.dart';
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
              heroTag: "a",
              child: const Icon(Icons.add)
          )),
          withPadding(FloatingActionButton(
              onPressed: () {
                headerKey.currentState!.updateText(() {});
              },
              tooltip: '测试 Header',
              heroTag: "b",
              child: const Icon(Icons.edit))),
          withPadding(FloatingActionButton(heroTag: "c", onPressed: () {
            showSrDialog(context, (x) { updateBlur(x); });
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