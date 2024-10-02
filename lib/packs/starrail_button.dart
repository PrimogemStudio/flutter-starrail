import 'package:flutter/material.dart';

var srStyle = ButtonStyle(
    animationDuration: Duration(milliseconds: 150),
    overlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return Color.fromARGB(255, 190, 190, 190);
      }
      else if (states.contains(WidgetState.hovered)) {
        return Color.fromARGB(255, 235, 235, 235);
      }
      return Color.fromARGB(255, 225, 225, 225);
    }),
    foregroundColor: WidgetStateProperty.all(Colors.black),
    shape: WidgetStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.circular(0))),
    backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return Color.fromARGB(255, 225, 225, 225);
    }),
    elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return 0;
      }
      return 4;
    }),
    splashFactory: NoSplash.splashFactory
);