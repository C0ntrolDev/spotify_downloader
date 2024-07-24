import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar.dart';

class OrientatedNavigationBar extends StatefulWidget {
  const OrientatedNavigationBar(
      {super.key,
      required this.items,
      required this.onTap,
      required this.currentIndex,
      this.horizontalNavigationBarTheme = const HorizontalNavigationBarTheme(),
      this.verticalNavigationBarTheme = const VerticalNavigationBarTheme(),
      required this.expandBody,
      required this.child});

  final Widget child;

  final List<OrientatedNavigationBarItem> items;
  final void Function(int index) onTap;
  final int currentIndex;

  final HorizontalNavigationBarTheme horizontalNavigationBarTheme;
  final VerticalNavigationBarTheme verticalNavigationBarTheme;
  final bool expandBody;

  @override
  State<OrientatedNavigationBar> createState() => _OrientatedNavigationBarState();
}

class _OrientatedNavigationBarState extends State<OrientatedNavigationBar> {
  final GlobalKey _verticalNavigationBarKey = GlobalKey();

  double? _expandedHeight;

  @override
  Widget build(BuildContext context) {
    _scheduleExpandedHeightUpdate();

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final child = OrientatedNavigationBarAcessor(expandedHeight: _expandedHeight, child: widget.child);

        if (orientation == Orientation.portrait) {
          final verticalNavigationBar = VerticalNavigationBar(
              key: _verticalNavigationBarKey,
              theme: widget.verticalNavigationBarTheme,
              items: widget.items,
              onTap: widget.onTap,
              currentIndex: widget.currentIndex);

          if (widget.expandBody) {
            return Stack(
              children: [child, Align(alignment: Alignment.bottomCenter, child: verticalNavigationBar)],
            );
          } else {
            return Column(
              children: [child, verticalNavigationBar],
            );
          }
        }

        return Row(
          children: [
            HorizontalNavigationBar(
                theme: widget.horizontalNavigationBarTheme,
                items: widget.items,
                onTap: widget.onTap,
                currentIndex: widget.currentIndex),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  void _scheduleExpandedHeightUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      double? newExpandedHeight;

      if (widget.expandBody) {
        newExpandedHeight = (_verticalNavigationBarKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
      } else {
        newExpandedHeight = null;
      }

      if (newExpandedHeight != _expandedHeight) {
        setState(() {
          _expandedHeight = newExpandedHeight;
        });
      }
    });
  }
}
