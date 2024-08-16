import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FtoastAccessor extends InheritedWidget {
  final FToast fToast;

  const FtoastAccessor({super.key, required super.child, required this.fToast});

  static FtoastAccessor? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FtoastAccessor>();
  }

  static FtoastAccessor of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FtoastAccessor>()!;
  }

  @override
  bool updateShouldNotify(FtoastAccessor oldWidget) {
    return oldWidget.fToast.context != fToast.context;
  }
}
