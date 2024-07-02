import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarObserver extends AutoRouteObserver {
  final void Function(Route? newRoute) onRouteChanged;

  BottomNavigationBarObserver({required this.onRouteChanged});

  @override
  void didPop(Route route, Route? previousRoute) {
    onRouteChanged.call(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    onRouteChanged.call(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    onRouteChanged.call(newRoute);
  }
}
