import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

void showSrDialog(BuildContext context, Function onAnimation) {
  showGeneralDialog(
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    barrierLabel: "",
    context: context,
    pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return AlertDialog(
        backgroundColor: uiDialogBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))
        ),
        title: const Text("提示"),
        content: const Text("确定删除吗？"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消"),
          ),
          TextButton(onPressed: () {}, child: const Text("确定")),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      animation.addListener(() { onAnimation(animation.value * 5); });
      return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(
          begin: const Offset(0, 0.1), end: const Offset(0, 0))
          .animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutExpo,
          reverseCurve: Curves.easeOutExpo)), child: child));
    },
  );
}