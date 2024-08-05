import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';

class VerticalNavigationBarItemTile extends OrientatedNavigationBarItemTile {
  final EdgeInsets itemPadding;

  const VerticalNavigationBarItemTile(
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
      required this.itemPadding});

  @override
  State<VerticalNavigationBarItemTile> createState() => _VerticalNavigationBarItemTileState();
}

class _VerticalNavigationBarItemTileState extends OrientatedNavigationBarItemTileState<VerticalNavigationBarItemTile> {
  @override
  Widget buildWithAnimations(double animatedSize, Color animatedColor) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: widget.itemPadding,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.isSelected ? widget.item.svgActiveIconPath : widget.item.svgIconPath,
              width: widget.iconSize.width * sizeAnimation!.value,
              height: widget.iconSize.height * sizeAnimation!.value,
              colorFilter: ColorFilter.mode(colorAnimation!.value!, BlendMode.srcIn),
            ),
            Text(widget.item.label,
                style: TextStyle(color: colorAnimation!.value, fontSize: widget.labelFontSize * sizeAnimation!.value))
          ],
        ),
      ),
    );
  }
}
