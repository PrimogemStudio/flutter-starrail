import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';
import 'package:flutter_starrail/packs/starrail_button.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'dart:math';

class ChatMainPage extends StatefulWidget {
  ChatMainPage({super.key});

  AnimationController? panelAnimation;
  Animation? panelTween;
  Animation<double>? panelRt;
  Animation<double>? panelOpacity;

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage> with TickerProviderStateMixin {
  GlobalKey<StarRailListState> key = GlobalKey<StarRailListState>();
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

  void addMsg() async {
    /*var a = await const MethodChannel('MainPage.Event')
        .invokeMethod("testPrint", Random().nextInt(100));
    var b = await const BasicMessageChannel('Channel2', StandardMessageCodec())
        .send("Hello minecraft");*/
    ListTile tt = ListTile(
        title: ChatMessageLine(
            avatar: Image.asset("assets/avatars/jack253-png.png",
                width: 50.0, height: 50.0),
            self: false,
            username: "Coder2",
            // text: '$a,$b',
            text: "Test!",
            msgResv: false,
            onLoadComplete: () {
              setState(() {
                key.currentState!.scrollToBottom();
              });
              Future.delayed(Duration(milliseconds: 1500), () {
                widget.panelAnimation ??= AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
                if (widget.panelAnimation!.isAnimating) return;
                widget.panelAnimation!.reset();

                widget.panelRt ??= CurveTween(curve: Curves.fastOutSlowIn).animate(widget.panelAnimation!); // Cubic(.33, .26, 0, .97)
                widget.panelTween ??= Tween(begin: 0.0, end: 180.0).animate(widget.panelRt!);
                widget.panelTween!.addListener(() {
                  panelHeight = widget.panelTween!.value;
                  setState(() {
                    key.currentState!.scrollToBottomImm();
                  });
                });

                widget.panelOpacity ??= Tween(begin: 0.0, end: 1.0).animate(CurveTween(curve: Curves.easeInBack).animate(widget.panelAnimation!));
                widget.panelOpacity!.addListener(() {
                  panelOpacity = max(widget.panelOpacity!.value, 0);
                });

                widget.panelAnimation!.forward();
              });
            }));

    setState(() {
      key.currentState!.pushMsg(tt);
    });
  }

  double panelHeight = 0;
  double panelOpacity = 0;

  @override
  Widget build(BuildContext context) {
    Scaffold sc = Scaffold(
        body: StarRailList(key: key, innerPanel: Opacity(opacity: panelOpacity, child: Container(height: panelHeight, color: uiPanelBack, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: 2147483647,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    uiPanelBorder,
                    uiPanelBorderTrans
                  ]),
            ),
          ),
          TextField(),
          Padding(padding: EdgeInsets.all(5)),
          Padding(padding: EdgeInsets.all(10), child: ElevatedButton(
              onPressed: () {
                widget.panelAnimation!.animateBack(0);
                Future.delayed(Duration(milliseconds: 550), () => addMsg());
              },
              style: srStyle,
              child: const Text("Test!")
          ))
        ])
        ))),
        appBar: AppBar(
            backgroundColor: uiSurfaceColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            title: ChatHeader(),
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent),
        floatingActionButton: FloatingActionButton(
          onPressed: addMsg,
          tooltip: '添加测试信息',
          child: const Icon(Icons.add),
        ));
    return ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        child: sc);
  }
}
