import 'package:flutter/material.dart';
import 'package:flutter_starrail/packs/dialogs/starrail_chatimage_dialog.dart';
import 'package:flutter_starrail/packs/starrail_colors.dart';

void showSrDialog(BuildContext context, Function onAnimation) {
  showGeneralDialog(
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    barrierLabel: "",
    context: context,
    pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return StarRailChatImageDialog();
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