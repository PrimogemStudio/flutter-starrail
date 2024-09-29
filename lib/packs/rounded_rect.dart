import 'package:flutter/material.dart';

class RoundedRect extends Container {
  RoundedRect(
      {super.key,
      required super.width,
      required super.height,
      required this.radius,
      required super.color,
      super.alignment});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius * 2)),
        child: super.build(context));
  }
}
