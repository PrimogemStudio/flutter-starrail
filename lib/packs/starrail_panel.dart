import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_button.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

class StarRailPanel extends StatefulWidget {
  StarRailPanel({
    super.key,
    required this.func,
    required this.onMoving
  });

  AnimationController? animationBase;
  Animation? panelTween;
  Animation<double>? panelRt;
  Animation<double>? panelOpacity;
  Function func;
  Function onMoving;

  @override
  State<StatefulWidget> createState() => StarRailPanelState();
}

class StarRailPanelState extends State<StarRailPanel> with TickerProviderStateMixin {
  TextEditingController textCont = TextEditingController();
  double mainOpac = 0;
  double panelHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.animationBase = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    widget.panelRt = CurveTween(curve: Curves.fastOutSlowIn).animate(widget.animationBase!); // Cubic(.33, .26, 0, .97)
    widget.panelTween = Tween(begin: 0.0, end: 180.0).animate(widget.panelRt!);
    widget.panelTween!.addListener(() {
      panelHeight = widget.panelTween!.value;
      setState(() {
        widget.onMoving();
      });
    });

    widget.panelOpacity = Tween(begin: 0.0, end: 1.0).animate(CurveTween(curve: Curves.easeInBack).animate(widget.animationBase!));
    widget.panelOpacity!.addListener(() {
      mainOpac = max(widget.panelOpacity!.value, 0);
    });
  }

  @override
  void didUpdateWidget(covariant StarRailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.animationBase = oldWidget.animationBase;
    widget.panelTween = oldWidget.panelTween;
    widget.panelRt = oldWidget.panelRt;
    widget.panelOpacity = oldWidget.panelOpacity;
  }

  void openPanel() {
    widget.animationBase!.forward(from: 0);
  }

  void closePanel() {
    widget.animationBase!.animateTo(0);
  }

  String getText() {
    return textCont.text;
  }

  @override
  Widget build(BuildContext context) {
    var i = Container(height: panelHeight, color: uiPanelBack, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        width: 2147483647,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                uiPanelBorder,
                uiPanelBorderTrans
              ]),
        ),
      ),
      TextField(controller: textCont),
      Padding(padding: EdgeInsets.all(5)),
      Padding(padding: EdgeInsets.all(10), child: ElevatedButton(
          onPressed: () {
            closePanel();
            Future.delayed(Duration(milliseconds: 450), () => widget.func());
          },
          style: srStyle,
          child: const Text("Test!")
      ))
    ]));
    return Opacity(opacity: mainOpac, child: i);
  }
}