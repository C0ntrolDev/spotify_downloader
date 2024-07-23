import 'package:flutter/material.dart';

class CustomNavigationBarAcessor extends InheritedWidget {
  final double? expandedHeight;

  const CustomNavigationBarAcessor({super.key, required super.child, required this.expandedHeight});

  @override
  bool updateShouldNotify(covariant CustomNavigationBarAcessor oldWidget) {
    return oldWidget.expandedHeight != expandedHeight;
  }

  static CustomNavigationBarAcessor of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CustomNavigationBarAcessor>() as CustomNavigationBarAcessor;
}
