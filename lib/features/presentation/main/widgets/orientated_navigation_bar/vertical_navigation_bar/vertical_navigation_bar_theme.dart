import 'package:flutter/material.dart';

class VerticalNavigationBarTheme {
  final double? height;
  final EdgeInsets contentPadding;
  final BoxDecoration backgroundDecorations;
  final EdgeInsets itemPadding;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const VerticalNavigationBarTheme(
      {this.height,
      this.contentPadding = EdgeInsets.zero,
      this.backgroundDecorations = const BoxDecoration(),
      this.itemPadding = const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      this.iconSize = const Size(25, 25),
      this.labelFontSize = 10,
      this.selectingSize = 1.0,
      this.selectedItemColor = Colors.white,
      this.unselectedItemColor = Colors.white,
      this.selectingItemColor = Colors.white,
      this.animationDuration = const Duration(milliseconds: 50),
      this.animationCurve = Curves.linear});
}
