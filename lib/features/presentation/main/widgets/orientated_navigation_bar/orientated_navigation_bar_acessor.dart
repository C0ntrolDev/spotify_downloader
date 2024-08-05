import 'package:flutter/material.dart';

class OrientatedNavigationBarAcessor extends InheritedWidget {
  final double? expandedHeight;

  const OrientatedNavigationBarAcessor({super.key, required super.child, required this.expandedHeight});

  @override
  bool updateShouldNotify(covariant OrientatedNavigationBarAcessor oldWidget) {
    return oldWidget.expandedHeight != expandedHeight;
  }

  static OrientatedNavigationBarAcessor? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OrientatedNavigationBarAcessor>();
}
