import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoAccessor extends InheritedWidget {
  const PackageInfoAccessor({super.key, required super.child, required this.packageInfo});

  final PackageInfo packageInfo;

  static PackageInfoAccessor? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PackageInfoAccessor>();
  }

  @override
  bool updateShouldNotify(PackageInfoAccessor oldWidget) {
    return oldWidget.packageInfo != packageInfo;
  }
}
