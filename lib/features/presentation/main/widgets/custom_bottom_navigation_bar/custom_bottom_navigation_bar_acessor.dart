import 'package:flutter/material.dart';

class CustomBottomNavigationBarAcessor extends InheritedWidget {
  final double? height;

  const CustomBottomNavigationBarAcessor({super.key, required super.child, required this.height});

  @override
  bool updateShouldNotify(covariant CustomBottomNavigationBarAcessor oldWidget) {
    return oldWidget.height != height;
  }

  static CustomBottomNavigationBarAcessor of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CustomBottomNavigationBarAcessor>() as CustomBottomNavigationBarAcessor;
}
