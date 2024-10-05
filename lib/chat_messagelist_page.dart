import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';

class ChatMessageListPage extends StatefulWidget {
  const ChatMessageListPage({super.key});

  @override
  State<StatefulWidget> createState() => ChatMessageListPageState();
}

class ChatMessageListPageState extends State<ChatMessageListPage> {
  GlobalKey<StarRailListState> userListKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.cyanAccent, child: StarRailList(key: userListKey, innerPanel: Container()));
  }
}