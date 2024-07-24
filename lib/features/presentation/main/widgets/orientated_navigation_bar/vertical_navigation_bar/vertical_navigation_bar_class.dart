import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';

class VerticalNavigationBar extends StatelessWidget {
  final List<OrientatedNavigationBarItem> items;
  final void Function(int index) onTap;
  final int currentIndex;

  final VerticalNavigationBarTheme theme;

  const VerticalNavigationBar(
      {super.key, required this.items, required this.onTap, required this.currentIndex, required this.theme});

  @override
  Widget build(BuildContext context) {
    final navigaitonBarTiles = List<Widget>.empty(growable: true);
    for (var i = 0; i < items.length; i++) {
      final isSelected = i == currentIndex;
      navigaitonBarTiles.add(Expanded(
          child: VerticalNavigationBarItemTile(
        item: items[i],
        iconSize: theme.iconSize,
        itemPadding: theme.itemPadding,
        labelFontSize: theme.labelFontSize,
        selectedItemColor: theme.selectedItemColor,
        selectingItemColor: theme.selectingItemColor,
        selectingSize: theme.selectingSize,
        unselectedItemColor: theme.unselectedItemColor,
        isSelected: isSelected,
        onTap: () => onTap(i),
        animationDuration: theme.animationDuration,
        animationCurve: theme.animationCurve,
      )));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: theme.height,
            padding: theme.contentPadding,
            alignment: Alignment.bottomCenter,
            decoration: theme.backgroundDecorations,
            child: SafeArea(
              left: false,
              right: false,
              top: false,
              child: Theme(
                  data: ThemeData(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Row(children: navigaitonBarTiles)),
            )),
      ],
    );
  }
}
