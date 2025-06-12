import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.theresSomethingWrongWithConnection,
          style: theme.textTheme.titleLarge,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            onPressed: onRetryAgainButtonClicked,
            child: Text(
              AppLocalizations.of(context)!.tryAgain,
              style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
            ))
      ],
    ));
  }
}
