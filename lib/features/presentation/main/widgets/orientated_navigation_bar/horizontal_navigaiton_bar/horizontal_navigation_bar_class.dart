import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';

class HorizontalNavigationBar extends StatelessWidget {
  final List<OrientatedNavigationBarItem> items;
  final void Function(int index) onTap;
  final int currentIndex;

  final HorizontalNavigationBarTheme theme;

  const HorizontalNavigationBar(
      {super.key, required this.items, required this.currentIndex, required this.onTap, required this.theme});

  @override
  Widget build(BuildContext context) {
    final navigaitonBarTiles = List<Widget>.empty(growable: true);
    for (var i = 0; i < items.length; i++) {
      final isSelected = i == currentIndex;
      navigaitonBarTiles.add(HorizontalNavigationBarItemTile(
        item: items[i],
        iconSize: theme.iconSize,
        labelFontSize: theme.labelFontSize,
        selectedItemColor: theme.selectedItemColor,
        selectingItemColor: theme.selectingItemColor,
        selectingSize: theme.selectingSize,
        unselectedItemColor: theme.unselectedItemColor,
        isSelected: isSelected,
        onTap: () => onTap(i),
        animationDuration: theme.animationDuration,
        animationCurve: theme.animationCurve,
        textPadding: theme.textPadding,
        height: theme.itemContentHeight,
        contentPadding: theme.itemContentPadding,
      ));
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(width: MediaQuery.of(context).viewPadding.left, color: backgroundColor),
        Container(
            padding: theme.contentPadding,
            width: theme.width,
            alignment: Alignment.topLeft,
            decoration: theme.backgroundDecorations,
            child: SafeArea(
              left: false,
              right: false,
              child: Theme(
                  data: ThemeData(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Column(children: navigaitonBarTiles)),
            )),
      ],
    );
  }
}
