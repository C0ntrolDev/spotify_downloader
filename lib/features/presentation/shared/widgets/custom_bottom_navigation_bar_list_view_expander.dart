import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar_acessor.dart';

class OrientatedNavigationBarListViewExpander extends StatelessWidget {
  const OrientatedNavigationBarListViewExpander({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: OrientatedNavigationBarAcessor.maybeOf(context)?.expandedHeight ?? 0);
  }
}
