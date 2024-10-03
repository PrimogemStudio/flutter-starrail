import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';
import 'package:flutter_starrail/packs/starrail_panel.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'main.dart';

const currentUser = "hackerm大神";
const currentAvatar = "hackermdch";

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
      var json = JsonDecoder().convert(String.fromCharCodes(data));
      addMsg(json["msg"], json["username"], json["avatar"], false);
    });
  }

  void addMsg(String msg, String username, String avatar, bool self) async {
    ListTile tt = ListTile(
        title: ChatMessageLine(
            avatar: Image.asset("assets/avatars/$avatar.png",
                width: 50.0, height: 50.0),
            self: self,
            username: username,
            text: msg,
            msgResv: false,
            onLoadComplete: () {
              setState(() {
                key.currentState!.scrollToBottom();
              });
            }));

    setState(() => key.currentState!.pushMsg(tt));
  }

  void sendMsg(String s) async {
    addMsg(s, currentUser, currentAvatar, true);
    var json = {"msg": s, "username": currentUser, "avatar": currentAvatar};
    socket!.write(JsonEncoder().convert(json));
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
                  sendMsg(panelKey.currentState!.getText());
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
