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
            showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.red,
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
            );
          }))
        ]));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: sc);
  }
}