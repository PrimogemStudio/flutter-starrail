import 'package:flutter/material.dart';

import 'headers/header_chatting.dart';

const replyer = "hackerm大神";
const replyerDesc = "一个一般路过的普通开发者~";

class ChatHeader extends StatefulWidget {
  ChatHeader({super.key});

  AnimationController? mainAnimation;
  Animation<double>? opacityAnimation;
  Animation<Offset>? offsetAnimation;

  @override
  State<StatefulWidget> createState() => ChatHeaderState();
}

class ChatHeaderState extends State<ChatHeader> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.mainAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    widget.opacityAnimation = CurveTween(curve: Curves.easeOutExpo).animate(widget.mainAnimation!);
    widget.offsetAnimation = Tween<Offset>(
        begin: const Offset(0.15, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
        parent: widget.mainAnimation!,
        curve: Curves.easeOutExpo,
        reverseCurve: Curves.easeOutExpo));
    widget.mainAnimation!.forward();
  }

  @override
  void didUpdateWidget(covariant ChatHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.mainAnimation = oldWidget.mainAnimation;
    widget.opacityAnimation = oldWidget.opacityAnimation;
    widget.offsetAnimation = oldWidget.offsetAnimation;
  }

  void updateText(Function t) async {
    var c = widget.mainAnimation!;

    c.reverse();
    t();
    Future.delayed(Duration(milliseconds: 700), () {
      c.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: widget.offsetAnimation!, child: FadeTransition(opacity: widget.opacityAnimation!, child: Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: HeaderChatting(replyer: replyer, replyerDesc: replyerDesc))));
  }
}
