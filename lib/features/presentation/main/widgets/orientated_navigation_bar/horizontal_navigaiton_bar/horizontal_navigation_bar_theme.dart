import 'package:flutter/material.dart';

class HorizontalNavigationBarTheme {
  final double? width;
  final EdgeInsets contentPadding;
  final BoxDecoration backgroundDecorations;
  final EdgeInsets textPadding;
  final EdgeInsets itemContentPadding;
  final double? itemContentHeight;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const HorizontalNavigationBarTheme(
      {this.width,
      this.contentPadding = EdgeInsets.zero,
      this.backgroundDecorations = const BoxDecoration(),
      this.itemContentHeight,
      this.itemContentPadding = const EdgeInsets.only(bottom: 10),
      this.iconSize = const Size(25, 25),
      this.textPadding = const EdgeInsets.only(left: 10),
      this.labelFontSize = 10,
      this.selectingSize = 1.0,
      this.selectedItemColor = Colors.white,
      this.unselectedItemColor = Colors.white,
      this.selectingItemColor = Colors.white,
      this.animationDuration = const Duration(milliseconds: 50),
      this.animationCurve = Curves.linear});
}
