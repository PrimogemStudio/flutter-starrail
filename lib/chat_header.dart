import 'package:flutter/material.dart';

const replyer = "Coder2";
const replyerDesc = "Advanced Framework 主开发者";

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(replyer, style: TextStyle(fontSize: 18)),
              Text(replyerDesc,
                  style: TextStyle(fontSize: 13, color: Colors.grey))
            ]));
  }
}
