import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_button.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

import '../animatable.dart';

class StarRailUserObject extends StatefulWidget implements AnimatableObj {
  StarRailUserObject({super.key, required this.avatar, required this.title, required this.subtitle});

  Animation<double>? animation;
  Image avatar;
  String title;
  String subtitle;

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
    return TextButton(onPressed: () {}, style: srStyle, child: FadeTransition(
        opacity: widget.animation!,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.avatar,
            Expanded(child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 6), child: Text(widget.title)),
                      Text(widget.subtitle, style: TextStyle(color: uiMsgSrc))
                    ])))
          ])),
          Icon(Icons.arrow_forward_ios_rounded, size: 22)
        ])));
  }
}
