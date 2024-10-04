import 'package:flutter/material.dart';

const replyer = "hackerm大神";
const replyerDesc = "一个一般路过的普通开发者~";

class ChatHeader extends StatefulWidget {
  ChatHeader({super.key});

  AnimationController? mainAnimation;

  @override
  State<StatefulWidget> createState() => ChatHeaderState();
}

class ChatHeaderState extends State<ChatHeader> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.mainAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void didUpdateWidget(covariant ChatHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.mainAnimation = oldWidget.mainAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: widget.mainAnimation!, child: const Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(replyer, style: TextStyle(fontSize: 18)),
              Text(replyerDesc,
                  style: TextStyle(fontSize: 13, color: Colors.grey))
            ])));
  }
}
