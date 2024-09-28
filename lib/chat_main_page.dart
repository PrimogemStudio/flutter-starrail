import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'packs/rounded_rect.dart';
import 'dart:math';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({super.key});

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage> {
  List<Widget> list = [];
  AnimatedList? view;
  final ScrollController _controller = ScrollController();
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();

  void addMsg() {
    ListTile tt = ListTile(title: ChatMessageLine(
              avatar: Image.asset("assets/avatars/jack253-png.png", width: 50.0, height: 50.0), 
              self: false,
              username: "Coder2",
              text: "测试！" * (Random().nextInt(5) + 1),
              msgResv: false, 
              onLoadComplete: () => scrollToBottom()
            ));
    
    setState(() { 
      list = List.from(list);
      list.add(tt);
      key.currentState!.insertItem(list.length - 1);
      scrollToBottom();
    });
  }

  double _offset = 0;
  double _height = 0;
  double _schHeight = 0;

  @override
  void initState() { 
    super.initState();
    var c;
    c = (t) {
      SchedulerBinding.instance.addPostFrameCallback((Duration d) {
        setState(() {
          if (_controller.positions.isEmpty) return;
          var extentInside = key.currentContext!.size!.height;
          var maxScrollExtent = _controller.position.maxScrollExtent;
          var pixels = _controller.offset;

          _height = extentInside - 78;
          _schHeight = _height * (extentInside / (extentInside + maxScrollExtent));
          _offset = (_height - _schHeight) * (pixels / maxScrollExtent);
          if (_offset.isNaN) { _offset = 0; }
          if (dragging) { _controller.jumpTo(targetOff); }
        });
      });
      WidgetsBinding.instance.addPostFrameCallback(c);
    };
    WidgetsBinding.instance.addPostFrameCallback(c);
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (_controller.positions.isEmpty) return;
      _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 750), curve: Curves.easeOutExpo);
    });
  }

  Offset? dragOff;
  double currOff = 0;
  bool dragging = false;
  double targetOff = 0;
  double tt = 0;

  @override
  Widget build(BuildContext context) {
    view = AnimatedList(key: key, initialItemCount: list.length, 
      itemBuilder: (context, index, animation) {
        ((list[index] as ListTile).title as ChatMessageLine).animation = animation;
        return list[index];
      }, 
      controller: _controller, physics: const BouncingScrollPhysics(),
    );

    var bar = Column(children: [
            const Icon(Icons.keyboard_arrow_up, size: 14), 
            Stack(
              alignment: Alignment.topRight,
              children: [
                RoundedRect(width: 2.2, height: _height, radius: 0, color: const Color.fromARGB(255, 185, 185, 185)), 
                Positioned(top: _offset, child: RoundedRect(width: 2.2, height: _schHeight, radius: 0, color: const Color.fromARGB(255, 95, 95, 95)))
              ],
            ), 
            const Icon(Icons.keyboard_arrow_down, size: 14)
          ]);

    Scaffold sc = Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(children: [
            Expanded(child: ScrollConfiguration(behavior: const ScrollBehavior().copyWith(scrollbars: false), child: Listener(
              child: view!, 
              onPointerMove: (e) { targetOff = (dragOff!.dy - e.localPosition.dy) + currOff; }, 
              onPointerDown: (e) { dragOff = e.localPosition; currOff = _controller.offset; targetOff = currOff; dragging = e.buttons == 1; }, 
              onPointerUp: (e) { dragging = false; }
              )
            )), 
            Padding(padding: EdgeInsets.only(top: tt)),
          ]), 
          Padding(padding: const EdgeInsets.only(
            left: 10, right: 10, top: 10, bottom: 20
          ), child: Listener(
              child: bar, 
              onPointerMove: (e) { targetOff = - (dragOff!.dy - e.localPosition.dy) + currOff; }, 
              onPointerDown: (e) { dragOff = e.localPosition; currOff = _controller.offset; targetOff = currOff; dragging = e.buttons == 1; }, 
              onPointerUp: (e) { dragging = false; }
            ))
        ],
      ), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235), // Theme.of(context).colorScheme.inversePrimary,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: ChatHeader(), 
        scrolledUnderElevation: 3.0, 
        surfaceTintColor: Colors.transparent, 
        bottom: PreferredSize(preferredSize: const Size(1, 1), child: Container(width: 2147483647, height: 1, color: const Color.fromARGB(125, 155, 155, 155))),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addMsg,
          tooltip: '添加测试信息',
          child: const Icon(Icons.add),
        )
    );
    return ClipRRect(borderRadius: const BorderRadius.only(
      topRight: Radius.circular(30)
    ), child: sc);
  }
}
