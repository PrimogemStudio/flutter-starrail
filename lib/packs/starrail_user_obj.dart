import 'package:flutter/material.dart';

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
    return Text("datattt");
  }
}