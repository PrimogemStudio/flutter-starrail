import 'package:flutter/material.dart';

import '../starrail_colors.dart';

class StarRailChatImageDialog extends StatelessWidget {
  const StarRailChatImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: uiDialogBg,
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
      titlePadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))
      ),
      content: Stack(alignment: Alignment.bottomCenter, children: [
        Padding(padding: EdgeInsets.only(bottom: 30), child: Image.network("https://www.imagehub.cc/content/images/system/home_cover_1670160663727_f2dcdb.jpeg")),
        const Text("点击任意位置关闭")
      ]),
      actions: []
    );
  }
}