import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/features/presentation/shared/widgets/custom_app_bar.dart';

class ScrollableScreenWithCustomAppBar extends StatelessWidget {
  final String title;
  final Widget body;

  const ScrollableScreenWithCustomAppBar({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: title),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(padding: screenWithCustomAppBarPadding, child: body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}