import 'package:flutter/material.dart';
import 'package:flutter_starrail/network/socket.dart';
import 'package:flutter_starrail/packs/starrail_list.dart';
import 'package:flutter_starrail/packs/starrail_panel.dart';
import 'packs/starrail_message_line.dart';

const currentUser = "Coder2";
const currentAvatar = "jack253-png";

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({super.key});

  @override
  State<ChatMainPage> createState() => ChatMainPageState();
}

class ChatMainPageState extends State<ChatMainPage>
    with TickerProviderStateMixin {
  GlobalKey<StarRailListState> key = GlobalKey<StarRailListState>();
  GlobalKey<StarRailPanelState> panelKey = GlobalKey<StarRailPanelState>();
  bool panelOpened = false;

  ChatMainPageState() {
    handlePacker(RecvMessagePacket, (packet) {
      packet as RecvMessagePacket;
      addMsg(packet.message, packet.user, packet.avatar, false);
    });
  }

  void addMsg(String msg, String username, String avatar, bool self) async {
    ListTile tt = ListTile(
        title: StarRailMessageLine(
            avatar: Image.asset("assets/avatars/$avatar.png",
                width: 50.0, height: 50.0),
            self: self,
            username: username,
            text: msg,
            msgResv: false,
            onLoadComplete: () {
              setState(() {
                key.currentState!.scrollToBottom();
              });
            }));

    setState(() => key.currentState!.pushMsg(tt));
  }

  void sendMsg(String s) {
    addMsg(s, currentUser, currentAvatar, true);
    socketSend(SendMessagePacket(message: s));
  }

  void openPanel() {
    if (!panelOpened) {
      panelKey.currentState!.openPanel();
      panelOpened = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StarRailList(
        key: key,
        innerPanel: StarRailPanel(
            key: panelKey,
            func: () {
              sendMsg(panelKey.currentState!.getText());
              panelOpened = false;
            },
            onMoving: () => key.currentState!.scrollToBottomImm()));
  }
}
