import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_navigation_bar/custom_navigation_bar_item.dart';

import 'custom_navigation_bar_item_tile.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<CustomNavigationBarItem> items;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final void Function(int index) onTap;
  final int currentIndex;

  const CustomNavigationBar(
      {super.key,
      required this.items,
      required this.iconSize,
      required this.labelFontSize,
      required this.selectedItemColor,
      required this.unselectedItemColor,
      required this.selectingItemColor,
      required this.onTap,
      required this.currentIndex,
      required this.selectingSize,
      required this.animationDuration});

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: items.map((item) {
          final isSelected = i == currentIndex;
          final itemIndex = i;
          i++;

          return Expanded(
              child: CustomNavigationBarItemTile(
            item: item,
            iconSize: iconSize,
            labelFontSize: labelFontSize,
            selectedItemColor: selectedItemColor,
            selectingItemColor: selectingItemColor,
            selectingSize: selectingSize,
            unselectedItemColor: unselectedItemColor,
            isSelected: isSelected,
            onTap: () => onTap(itemIndex),
            animationDuration: animationDuration,
          ));
        }).toList(),
      ),
    );
  }
}
