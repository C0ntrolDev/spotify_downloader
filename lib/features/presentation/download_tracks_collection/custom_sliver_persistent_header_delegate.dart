import 'dart:math';
import 'package:flutter/material.dart';

class CustomSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  CustomSliverPersistentHeaderDelegate(
      {required this.maxHeight, required this.minHeight, required this.child, this.onHeightCalculated});

  final double minHeight;
  final double maxHeight;
  final Widget child;
  final void Function(double height)? onHeightCalculated;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    onHeightCalculated?.call(max(minExtent, maxExtent - shrinkOffset));

    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(CustomSliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

