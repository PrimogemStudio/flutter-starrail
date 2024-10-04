import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_starrail/packs/rounded_rect.dart';

import 'starrail_message_line.dart';
import 'starrail_colors.dart';

class StarRailList extends StatefulWidget {
  const StarRailList({
    super.key,
    required this.innerPanel
  });

  final Widget? innerPanel;

  @override
  State<StatefulWidget> createState() => StarRailListState();
}

class StarRailListState extends State<StarRailList> {
  Offset? dragOff;
  double currOff = 0;
  bool dragging = false;
  bool draggingInner = false;
  double targetOff = 0;

  List<Widget> list = [];
  AnimatedList? view;
  final ScrollController _controller = ScrollController();
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();
  GlobalKey barKey = GlobalKey();

  double _offset = 0;
  double _height = 0;
  double _schHeight = 0;
  double _po = 1;

  void pushMsg(ListTile l) {
    setState(() {
      list.add(l);
      key.currentState!.insertItem(list.length - 1);
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (_controller.positions.isEmpty) return;
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutExpo);
    });
  }

  void scrollToBottomImm() {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutExpo);
  }

  @override
  void initState() {
    super.initState();
    dynamic c;
    c = (t) {
      SchedulerBinding.instance.addPostFrameCallback((Duration d) {
        setState(() {
          if (_controller.positions.isEmpty) return;
          var extentInside = key.currentContext!.size!.height;
          var maxScrollExtent = _controller.position.maxScrollExtent;
          var offset = _controller.offset;

          _height = extentInside - 30;
          _po = (extentInside + maxScrollExtent) /
              extentInside /
              _height *
              extentInside;
          _schHeight =
              _height * (extentInside / (extentInside + maxScrollExtent));
          _offset = (_height - _schHeight) * (offset / maxScrollExtent);
          if (_offset.isNaN) {
            _offset = 0;
          }
          if (dragging) {
            _controller.jumpTo(targetOff);
          }
        });
      });
      WidgetsBinding.instance.addPostFrameCallback(c);
    };
    WidgetsBinding.instance.addPostFrameCallback(c);

    _controller.addListener(() {
      final scrollDirection = _controller.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = _controller.offset +
            (scrollDirection == ScrollDirection.reverse ? -50 : 50);
        if (_controller.offset == _controller.position.minScrollExtent ||
            _controller.offset == _controller.position.maxScrollExtent) return;
        dragging = false;
        _controller.jumpTo(scrollEnd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    view = AnimatedList(
      key: key,
      initialItemCount: list.length,
      itemBuilder: (context, index, animation) {
        if ((list[index] as ListTile).title is StarRailMessageLine) {
          ((list[index] as ListTile).title as StarRailMessageLine).animation = animation;
        }
        return list[index];
      },
      controller: _controller,
      physics: const BouncingScrollPhysics(),
    );

    final innerBar = Listener(
        child: RoundedRect(
            width: 4,
            height: _schHeight,
            radius: 0,
            color: uiViewBarMain),
        onPointerMove: (e) {
          targetOff = (e.localPosition.dy - dragOff!.dy) * _po + currOff;
        },
        onPointerDown: (e) {
          dragOff = e.localPosition;
          currOff = _controller.offset;
          targetOff = currOff;
          dragging = e.buttons == 1;
          draggingInner = true;
        },
        onPointerUp: (e) {
          dragging = false;
          draggingInner = false;
        });
    final barBg = RoundedRect(
        key: barKey,
        width: 4,
        height: _height,
        radius: 0,
        color: uiViewBarBg
    );

    final mainBar = Padding(
        padding: const EdgeInsets.only(
            left: 10, right: 10, top: 10, bottom: 20),
        child: Listener(
          child: Column(children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                barBg,
                Positioned(top: _offset, child: innerBar)
              ],
            )
          ]),
          onPointerMove: (e) {
            targetOff =
                (e.localPosition.dy - dragOff!.dy) * _po + currOff;
          },
          onPointerUp: (e) {
            dragging = false;
          },
          onPointerDown: (e) {
            if (!draggingInner) {
              _controller.jumpTo(e.localPosition.dy /
                  _height *
                  (_height - _schHeight) *
                  _po);
            }
            dragOff = e.localPosition;
            currOff = _controller.offset;
            targetOff = currOff;
            dragging = e.buttons == 1;
            dragging = true;
          },
        ));

    final viewpanel = Expanded(child: ScrollConfiguration(
        behavior:
        const ScrollBehavior().copyWith(scrollbars: false),
        child: Listener(
            child: view!,
            onPointerMove: (e) {
              targetOff =
                  (dragOff!.dy - e.localPosition.dy) + currOff;
            },
            onPointerDown: (e) {
              dragOff = e.localPosition;
              currOff = _controller.offset;
              targetOff = currOff;
              dragging = e.buttons == 1;
            },
            onPointerUp: (e) {
              dragging = false;
            })));

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(children: [
          viewpanel,
          widget.innerPanel?? Container(),
        ]),
        mainBar,
        Column(children: [
          Container(
            width: 2147483647,
            height: 1,
            color: uiViewSplit,
          ),
          Container(
            width: 2147483647,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    uiSurfaceColor,
                    uiSurfaceColorTrans
                  ]),
            ),
          ),
        ])
      ],
    );
  }
}