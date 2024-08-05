import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/generated/l10n.dart';

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
          S.of(context).theresSomethingWrongWithConnection,
          style: theme.textTheme.titleLarge,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            onPressed: onRetryAgainButtonClicked,
            child: Text(
              S.of(context).tryAgain,
              style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
            ))
      ],
    ));
  }
}
