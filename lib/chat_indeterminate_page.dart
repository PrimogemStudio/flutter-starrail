import 'package:flutter/material.dart';
import 'package:flutter_starrail/chat_main_page.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

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
        floatingActionButton: Column(children: [
          FloatingActionButton(
              onPressed: () => mainPageKey.currentState!.openPanel(),
              tooltip: '添加测试信息',
              child: const Icon(Icons.add)),
          FloatingActionButton(
              onPressed: () {
                var c = headerKey.currentState!.widget.mainAnimation!;

                if (c.value == 1) { c.animateBack(0); }
                else { c.animateTo(1); }
              },
              tooltip: '测试 Header',
              child: const Icon(Icons.edit)),
        ]));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: sc);
  }
}