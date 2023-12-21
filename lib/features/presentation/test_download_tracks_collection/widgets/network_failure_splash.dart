import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

class NetworkFailureSplash extends StatelessWidget {
  const NetworkFailureSplash({super.key, required this.onRetryAgainButtonClicked});

  final void Function() onRetryAgainButtonClicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'С соединением что-то не так',
          style: theme.textTheme.titleLarge,
        ),
        TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            onPressed: onRetryAgainButtonClicked,
            child: Text(
              'Попробовать снова',
              style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
            ))
      ],
    ));
  }
}
