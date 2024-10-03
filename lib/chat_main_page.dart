import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';
import 'package:flutter_starrail/packs/starrail_panel.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'dart:math';

class ChatMainPage extends StatefulWidget {
  ChatMainPage({super.key});

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage> with TickerProviderStateMixin {
  GlobalKey<StarRailListState> key = GlobalKey<StarRailListState>();
  GlobalKey<StarRailPanelState> panelKey = GlobalKey<StarRailPanelState>();
  bool panelOpened = false;

  ChatMainPageState() {
    const MethodChannel('MainPage.Event').setMethodCallHandler((call) async {
      switch (call.method) {
        case "addMsg":
          /*final msg = call.arguments as String;
          ListTile tt = ListTile(
              title: ChatMessageLine(
                  avatar: Image.asset("assets/avatars/jack253-png.png",
                      width: 50.0, height: 50.0),
                  self: false,
                  username: "Coder2",
                  text: msg,
                  msgResv: false,
                  onLoadComplete: () => scrollToBottom()));

          setState(() {
            list.add(tt);
            key.currentState!.insertItem(list.length - 1);
            scrollToBottom();
          });*/
          break;
      }
      return Random().nextInt(5);
    });
    const BasicMessageChannel('Channel2', StandardMessageCodec())
        .setMessageHandler((message) async {
      /*ListTile tt = ListTile(
          title: ChatMessageLine(
              avatar: Image.asset("assets/avatars/jack253-png.png",
                  width: 50.0, height: 50.0),
              self: false,
              username: "Coder2",
              text: message.toString(),
              msgResv: false,
              onLoadComplete: () => scrollToBottom()));

      setState(() {
        list.add(tt);
        key.currentState!.insertItem(list.length - 1);
        scrollToBottom();
      });*/
    });
  }

  void addMsg(String s) async {
    /*var a = await const MethodChannel('MainPage.Event')
        .invokeMethod("testPrint", Random().nextInt(100));
    var b = await const BasicMessageChannel('Channel2', StandardMessageCodec())
        .send("Hello minecraft");*/
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

  @override
  Widget build(BuildContext context) {
    Scaffold sc = Scaffold(
        body: StarRailList(key: key, innerPanel:
          StarRailPanel(key: panelKey, func: () { addMsg(panelKey.currentState!.getText()); panelOpened = false; }, onMoving: () => key.currentState!.scrollToBottomImm())
        ),
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
          child: const Icon(Icons.add)
        ));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: sc);
  }
}
