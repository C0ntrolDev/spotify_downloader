import 'package:flutter/material.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class CustomBottomNavigationBarListViewExpander extends StatelessWidget {
  const CustomBottomNavigationBarListViewExpander({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: CustomBottomNavigationBarAcessor.of(context).height ?? 0);
  }
}
