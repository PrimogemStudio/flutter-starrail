import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'chat_header.dart';
import 'chat_message_line.dart';
import 'packs/rounded_rect.dart';
import 'dart:math';

class ChatMainPage extends StatefulWidget {
  ChatMainPage({super.key});

  AnimationController? panelAnimation;
  Animation? panelTween;
  Animation<double>? panelRt;

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage> with TickerProviderStateMixin {
  List<Widget> list = [];
  AnimatedList? view;
  final ScrollController _controller = ScrollController();
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();
  GlobalKey barKey = GlobalKey();

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
              scrollToBottom();
              Future.delayed(Duration(milliseconds: 1000), () {
                widget.panelAnimation ??= AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
                if (widget.panelAnimation!.isAnimating) return;
                widget.panelAnimation!.reset();

                widget.panelRt ??= CurveTween(curve: Curves.easeOutExpo).animate(widget.panelAnimation!);
                widget.panelTween ??= Tween(begin: 0.0, end: 200.0).animate(widget.panelRt!);
                widget.panelTween!.addListener(() {
                  panelHeight = widget.panelTween!.value;
                  panelOpacity = widget.panelRt!.value;
                  scrollToBottom();
                });

                widget.panelAnimation!.forward();
              });
            }));

    pushMsg(tt);
  }

  void pushMsg(ListTile l) {
    setState(() {
      list.add(l);
      key.currentState!.insertItem(list.length - 1);
      scrollToBottom();
    });
  }

  double _offset = 0;
  double _height = 0;
  double _schHeight = 0;
  double _po = 1;

  @override
  void initState() {
    super.initState();
    dynamic c;
    c = (t) {
      SchedulerBinding.instance.addPostFrameCallback((Duration d) {
        setState(() {
          if (_controller.positions.isEmpty) return;
          var extentInside = key.currentContext!.size!.height;
          var maxScrollExtent = _controller.position.maxScrollExtent;
          var offset = _controller.offset;

          _height = extentInside - 30;
          _po = (extentInside + maxScrollExtent) /
              extentInside /
              _height *
              extentInside;
          _schHeight =
              _height * (extentInside / (extentInside + maxScrollExtent));
          _offset = (_height - _schHeight) * (offset / maxScrollExtent);
          if (_offset.isNaN) {
            _offset = 0;
          }
          if (dragging) {
            _controller.jumpTo(targetOff);
          }
        });
      });
      WidgetsBinding.instance.addPostFrameCallback(c);
    };
    WidgetsBinding.instance.addPostFrameCallback(c);

    _controller.addListener(() {
      final scrollDirection = _controller.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = _controller.offset +
            (scrollDirection == ScrollDirection.reverse ? -50 : 50);
        if (_controller.offset == _controller.position.minScrollExtent ||
            _controller.offset == _controller.position.maxScrollExtent) return;
        dragging = false;
        _controller.jumpTo(scrollEnd);
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (_controller.positions.isEmpty) return;
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutExpo);
    });
  }

  Offset? dragOff;
  double currOff = 0;
  bool dragging = false;
  bool draggingInner = false;
  double targetOff = 0;
  double panelHeight = 0;
  double panelOpacity = 0;

  @override
  Widget build(BuildContext context) {
    view = AnimatedList(
      key: key,
      initialItemCount: list.length,
      itemBuilder: (context, index, animation) {
        ((list[index] as ListTile).title as ChatMessageLine).animation =
            animation;
        return list[index];
      },
      controller: _controller,
      physics: const BouncingScrollPhysics(),
    );

    final innerBar = Listener(
        child: RoundedRect(
            width: 4,
            height: _schHeight,
            radius: 0,
            color: const Color.fromARGB(255, 105, 105, 105)),
        onPointerMove: (e) {
          targetOff = (e.localPosition.dy - dragOff!.dy) * _po + currOff;
        },
        onPointerDown: (e) {
          dragOff = e.localPosition;
          currOff = _controller.offset;
          targetOff = currOff;
          dragging = e.buttons == 1;
          draggingInner = true;
        },
        onPointerUp: (e) {
          dragging = false;
          draggingInner = false;
        });
    final barBg = RoundedRect(
        key: barKey,
        width: 4,
        height: _height,
        radius: 0,
        color: const Color.fromARGB(255, 215, 215, 215));

    Scaffold sc = Scaffold(
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(children: [
              Expanded(
                  child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(scrollbars: false),
                      child: Listener(
                          child: view!,
                          onPointerMove: (e) {
                            targetOff =
                                (dragOff!.dy - e.localPosition.dy) + currOff;
                          },
                          onPointerDown: (e) {
                            dragOff = e.localPosition;
                            currOff = _controller.offset;
                            targetOff = currOff;
                            dragging = e.buttons == 1;
                          },
                          onPointerUp: (e) {
                            dragging = false;
                          }))),
              Opacity(opacity: panelOpacity, child: Container(height: panelHeight, color: Color.fromARGB(
                  255, 223, 223, 223), child: Column(children: [
                    Container(
                      width: 2147483647,
                      height: 3,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 200, 200, 200),
                              Color.fromARGB(0, 200, 200, 200)
                            ]),
                      ),
                    ),
                    TextField(),
                    ElevatedButton(
                        onPressed: () => widget.panelAnimation!.animateBack(0),
                        style: ButtonStyle(
                            overlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                              return Colors.transparent;
                            }),
                            foregroundColor: WidgetStateProperty.all(Colors.black),
                            shape: WidgetStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.circular(0))),
                            elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return 0;
                              }
                              else if (states.contains(WidgetState.hovered)) {
                                return 2;
                              }
                              return 2;
                            })
                        ),
                        child: const Text("Test!")
                    )
                  ])
              )),
            ]),
            Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 20),
                child: Listener(
                  child: Column(children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        barBg,
                        Positioned(top: _offset, child: innerBar)
                      ],
                    )
                  ]),
                  onPointerMove: (e) {
                    targetOff =
                        (e.localPosition.dy - dragOff!.dy) * _po + currOff;
                  },
                  onPointerUp: (e) {
                    dragging = false;
                  },
                  onPointerDown: (e) {
                    if (!draggingInner) {
                      _controller.jumpTo(e.localPosition.dy /
                          _height *
                          (_height - _schHeight) *
                          _po);
                    }
                    dragOff = e.localPosition;
                    currOff = _controller.offset;
                    targetOff = currOff;
                    dragging = e.buttons == 1;
                    dragging = true;
                  },
                )),
            Column(children: [
              Container(
                width: 2147483647,
                height: 1,
                color: const Color.fromARGB(255, 205, 205, 205),
              ),
              Container(
                width: 2147483647,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 235, 235, 235),
                        Color.fromARGB(0, 235, 235, 235)
                      ]),
                ),
              ),
            ])
          ],
        ),
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 235, 235, 235),
            shadowColor: const Color.fromARGB(255, 255, 255, 255),
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
