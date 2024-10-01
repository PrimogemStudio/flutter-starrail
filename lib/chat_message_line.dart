import 'package:flutter/material.dart';
import 'packs/rounded_rect.dart';
import 'dart:math';

class ChatMessageLine extends StatefulWidget {
  ChatMessageLine(
      {super.key,
      required this.avatar,
      required this.self,
      required this.username,
      required this.text,
      required this.msgResv,
      required this.onLoadComplete});

  final Image avatar;
  final bool self;
  final String username;
  final String text;
  final Function onLoadComplete;
  Animation<double>? animation;
  AnimationController? mainAnimation;
  AnimationController? msgAnimation;
  bool mainDisposed = false;
  bool msgDisposed = false;
  bool msgResv;

  @override
  State<ChatMessageLine> createState() => ChatMessageLineState();
}

class ChatMessageLineState extends State<ChatMessageLine> with TickerProviderStateMixin {
  double o = 0;
  double o2 = 0;
  double o3 = 0;

  static double toO(double d) {
    return (sin(d * 3.1415926 * 2) + 1) / 2 * 0.8 + 0.2;
  }

  @override
  void dispose() {
    widget.mainAnimation!.dispose();
    widget.msgAnimation!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.mainAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    widget.msgAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    widget.mainAnimation!.addListener(() {
      setState(() {
        o = toO(1 - widget.mainAnimation!.value);
        o2 = toO(1 - widget.mainAnimation!.value + 0.25);
        o3 = toO(1 - widget.mainAnimation!.value + 0.5);
      });
    });
    widget.mainAnimation!.repeat(reverse: true, max: 0.7);
    Future.delayed(
        Duration(
            milliseconds: min(
                (widget.text.length + widget.username.length) * 30 + 100,
                1500)), () {
      bool t = widget.msgResv;
      widget.msgResv = true;
      if (!t) widget.onLoadComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatarr = ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: widget.avatar,
    );
    final msgMain = Card(
        margin: const EdgeInsets.only(top: 5, left: 5),
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Row(children: [
          const Padding(padding: EdgeInsets.all(5)),
          RoundedRect(
              width: 10,
              height: 10,
              radius: 10,
              color: Colors.black.withOpacity(o)),
          const Padding(padding: EdgeInsets.all(1)),
          RoundedRect(
              width: 10,
              height: 10,
              radius: 10,
              color: Colors.black.withOpacity(o2)),
          const Padding(padding: EdgeInsets.all(1)),
          RoundedRect(
              width: 10,
              height: 10,
              radius: 10,
              color: Colors.black.withOpacity(o3)),
        ]));

    if (widget.msgResv) {
      widget.mainAnimation!.stop();
      widget.msgAnimation!.forward();
    }

    final msgMain2 = Card(
        elevation: 0,
        color: const Color.fromARGB(255, 184, 184, 184),
        margin: widget.self
            ? const EdgeInsets.fromLTRB(0, 0, 10, 5)
            : const EdgeInsets.fromLTRB(10, 5, 0, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: widget.self
                    ? const Radius.circular(10)
                    : const Radius.circular(0),
                topRight: widget.self
                    ? const Radius.circular(0)
                    : const Radius.circular(10),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(11.5))),
        child: Card(
            elevation: 0,
            color: const Color.fromARGB(255, 253, 253, 253),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: widget.self
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                    topRight: widget.self
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10))),
            margin: widget.self
                ? const EdgeInsets.fromLTRB(0, 0, 0.75, 2)
                : const EdgeInsets.fromLTRB(0.75, 0, 0, 2),
            child: Card(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.black, fontSize: 16.0),
                ))));
    return Padding(
        padding: const EdgeInsets.only(right: 35),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: widget.self ? TextDirection.rtl : TextDirection.ltr,
          children: <Widget>[
            SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 0.7), end: const Offset(0, 0))
                    .animate(CurvedAnimation(
                        parent: widget.animation!,
                        curve: Curves.easeOutBack,
                        reverseCurve: Curves.easeOutBack)),
                child:
                    FadeTransition(opacity: widget.animation!, child: avatarr)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection:
                  widget.self ? TextDirection.rtl : TextDirection.ltr,
              children: <Widget>[
                Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    margin: widget.self
                        ? const EdgeInsets.fromLTRB(0, 0, 10, 5)
                        : const EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: FadeTransition(
                        opacity: widget.animation!,
                        child: Text(widget.username,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 100, 100, 100))))),
                Stack(
                    textDirection:
                        widget.self ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      FadeTransition(
                          opacity: widget.animation!, child: msgMain),
                      widget.msgResv
                          ? FadeTransition(
                              opacity: widget.msgAnimation!, child: msgMain2)
                          : Container()
                    ])
              ],
            ))
          ],
        ));
  }
}
