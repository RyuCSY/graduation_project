import 'package:flutter/material.dart';

class OutlineTextStyle extends TextStyle {
  final Color txtColor;
  final Color lineColor;

  OutlineTextStyle({
    required this.txtColor,
    required this.lineColor,
  }) : super(inherit: true, fontSize: 48.0, color: txtColor, shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: lineColor),
          Shadow(
              // bottomRight
              offset: Offset(1.5, -1.5),
              color: lineColor),
          Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: lineColor),
          Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: lineColor),
        ]);
}
