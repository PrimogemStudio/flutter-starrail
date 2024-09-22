import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.transparent, 
      shadowColor: Colors.transparent, 
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[
          Text("Coder2", style: TextStyle(fontSize: 18)), 
          Text("Advanced Framework 主开发者", style: TextStyle(fontSize: 13, color: Colors.grey))
        ]
      )
    );
  }
}