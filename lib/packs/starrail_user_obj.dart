import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

import '../animatable.dart';

class StarRailUserObject extends StatefulWidget implements AnimatableObj {
  StarRailUserObject({super.key});

  Animation<double>? animation;

  @override
  void setAnimation(Animation<double> a) {
    animation = a;
  }

  @override
  State<StatefulWidget> createState() => StarRailUserObjectState();
}

class StarRailUserObjectState extends State<StarRailUserObject> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: widget.animation!, child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Image.asset("assets/avatars/jack253-png.png",
          width: 50.0, height: 50.0),
      Padding(padding: EdgeInsets.only(left: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Coder2"),
        Text("Test!", style: TextStyle(color: uiMsgSrc))
      ])), 
      Icon(Icons.arrow_forward_ios_rounded, size: 22)
    ]));
  }
}