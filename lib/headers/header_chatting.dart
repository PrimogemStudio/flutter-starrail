import 'package:flutter/material.dart';

class HeaderChatting extends StatelessWidget {
  HeaderChatting({
    super.key,
    required this.replyer,
    required this.replyerDesc
  });

  String replyer;
  String replyerDesc;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(replyer, style: TextStyle(fontSize: 18)),
          Text(replyerDesc,
              style: TextStyle(fontSize: 13, color: Colors.grey))
        ]);
  }
}