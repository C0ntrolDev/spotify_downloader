import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/base/orientated_navigation_bar_item_tile.dart';

class HorizontalNavigationBarItemTile extends OrientatedNavigationBarItemTile {
  final EdgeInsets textPadding;
  final double? height;
  final EdgeInsets contentPadding;

  const HorizontalNavigationBarItemTile(
      {super.key,
      required super.iconSize,
      required super.labelFontSize,
      required super.selectingSize,
      required super.selectedItemColor,
      required super.unselectedItemColor,
      required super.selectingItemColor,
      required super.onTap,
      required super.isSelected,
      required super.item,
      required super.animationDuration,
      required super.animationCurve,
      required this.textPadding,
      required this.height,
      required this.contentPadding});

  @override
  State<HorizontalNavigationBarItemTile> createState() => _CustomLeftNavigationBarItemTileState();
}

class _CustomLeftNavigationBarItemTileState
    extends OrientatedNavigationBarItemTileState<HorizontalNavigationBarItemTile> {
  @override
  Widget buildWithAnimations(double animatedSize, Color animatedColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: widget.height,
        padding: widget.contentPadding,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.isSelected ? widget.item.svgActiveIconPath : widget.item.svgIconPath,
              width: widget.iconSize.width * sizeAnimation!.value,
              height: widget.iconSize.height * sizeAnimation!.value,
              colorFilter: ColorFilter.mode(colorAnimation!.value!, BlendMode.srcIn),
            ),
            Padding(
              padding: widget.textPadding,
              child: Text(widget.item.label,
                  style:
                      TextStyle(color: colorAnimation!.value, fontSize: widget.labelFontSize * sizeAnimation!.value)),
            )
          ],
        ),
      ),
    );
  }
}
