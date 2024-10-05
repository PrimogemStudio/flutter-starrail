import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/chat_main_page.dart';
import 'package:flutter_starrail/chat_messagelist_page.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_dialog.dart';
import 'package:flutter_starrail/packs/starrail_user_obj.dart';
import 'package:flutter_starrail/packs/utils.dart';

import 'chat_header.dart';

class ChatIndeterminatePage extends StatefulWidget {
  ChatIndeterminatePage({
    super.key
  });

  AnimationController? mainAnimation;

  @override
  State<StatefulWidget> createState() => ChatIndeterminatePageState();
}

class ChatIndeterminatePageState extends State<ChatIndeterminatePage> with TickerProviderStateMixin {
  GlobalKey<ChatMainPageState> mainPageKey = GlobalKey();
  GlobalKey<ChatHeaderState> headerKey = GlobalKey();
  GlobalKey<ChatMessageListPageState> chatMessageListKey = GlobalKey();
  double blur = 0;

  @override
  void initState() {
    super.initState();

    widget.mainAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    widget.mainAnimation!.forward();
  }

  @override
  void didUpdateWidget(covariant ChatIndeterminatePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.mainAnimation = oldWidget.mainAnimation;
  }

  @override
  Widget build(BuildContext context) {
    Scaffold sc = Scaffold(
        body: Stack(
          children: [
            ChatMainPage(key: mainPageKey),
            IgnorePointer(child: FadeTransition(opacity: widget.mainAnimation!, child: ChatMessageListPage(key: chatMessageListKey)))
          ]
        ),
        appBar: AppBar(
            backgroundColor: uiSurfaceColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            title: ChatHeader(key: headerKey, replyer: "", replyerDesc: ""),
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
          })),
          withPadding(FloatingActionButton(heroTag: "d", onPressed: () {
            chatMessageListKey.currentState!.userListKey.currentState!.pushMsg(ListTile(title: StarRailUserObject()));
            headerKey.currentState!.updateText(() {});
          })),
          withPadding(FloatingActionButton(heroTag: "e", onPressed: () {
            setState(() {
              widget.mainAnimation!.value == 0 ? widget.mainAnimation!.forward() : widget.mainAnimation!.reverse();
            });
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