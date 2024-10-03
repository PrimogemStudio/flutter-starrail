import 'package:flutter/material.dart';

var srStyle = ButtonStyle(
    animationDuration: Duration(milliseconds: 150),
    overlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return Color.fromARGB(255, 190, 190, 190);
      }
      else if (states.contains(WidgetState.hovered)) {
        return Color.fromARGB(255, 250, 250, 250);
      }
      return Color.fromARGB(255, 240, 240, 240);
    }),
    foregroundColor: WidgetStateProperty.all(Colors.black),
    shape: WidgetStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.circular(0))),
    backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return Color.fromARGB(255, 240, 240, 240);
    }),
    elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return 0;
      }
      return 3;
    }),
    splashFactory: NoSplash.splashFactory, 
    textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16))
);