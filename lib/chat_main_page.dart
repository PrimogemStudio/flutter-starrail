import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starrail/main.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';
import 'package:flutter_starrail/packs/starrail_panel.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'dart:math';

import 'dart:io';

external Socket? socket;

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({super.key});

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage>
    with TickerProviderStateMixin {
  GlobalKey<StarRailListState> key = GlobalKey<StarRailListState>();
  GlobalKey<StarRailPanelState> panelKey = GlobalKey<StarRailPanelState>();
  bool panelOpened = false;

  ChatMainPageState() {
    socket!.listen((data) {
      addMsg(String.fromCharCodes(data));
    });
  }

  void addMsg(String s) async {
    ListTile tt = ListTile(
        title: ChatMessageLine(
            avatar: Image.asset("assets/avatars/jack253-png.png",
                width: 50.0, height: 50.0),
            self: true,
            username: "Coder2",
            text: s,
            msgResv: false,
            onLoadComplete: () {
              setState(() {
                key.currentState!.scrollToBottom();
              });
            }));

    setState(() => key.currentState!.pushMsg(tt));
  }

  void sendMsg(String s) async {
    socket!.write(s);
    await socket!.flush();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold sc = Scaffold(
        body: StarRailList(
            key: key,
            innerPanel: StarRailPanel(
                key: panelKey,
                func: () {
                  addMsg(panelKey.currentState!.getText());
                  panelOpened = false;
                },
                onMoving: () => key.currentState!.scrollToBottomImm())),
        appBar: AppBar(
            backgroundColor: uiSurfaceColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            title: ChatHeader(),
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!panelOpened) {
                panelKey.currentState!.openPanel();
                panelOpened = true;
              }
            },
            tooltip: '添加测试信息',
            child: const Icon(Icons.add)));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: sc);
  }
}
