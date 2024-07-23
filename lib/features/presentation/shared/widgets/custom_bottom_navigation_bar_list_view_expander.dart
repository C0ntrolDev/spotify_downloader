import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_navigation_bar/custom_navigation_bar_acessor.dart';

class CustomBottomNavigationBarListViewExpander extends StatelessWidget {
  const CustomBottomNavigationBarListViewExpander({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: CustomNavigationBarAcessor.of(context).expandedHeight ?? 0);
  }
}
