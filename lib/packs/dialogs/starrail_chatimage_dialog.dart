import 'package:flutter/material.dart';

import '../starrail_colors.dart';

class StarRailChatImageDialog extends StatelessWidget {
  const StarRailChatImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}