import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoasts.dart';
import 'package:spotify_downloader/generated/l10n.dart';

void showFailureSnackBar(BuildContext innerContext, String message, {Duration duration = const Duration(seconds: 2)}) {
  final ftoast = FtoastAccessor.of(innerContext).fToast;
  final copiedTextTheme = Theme.of(innerContext).textTheme.bodyMedium;
  final failureCopiedMessage = S.of(innerContext).failureCopied;

  showSmallTextSnackBar(innerContext, message, duration: duration, onTap: () {
    ftoast.removeCustomToast();
    Clipboard.setData(ClipboardData(text: message));

    showSnackBarWithFToastAndTextStyle(ftoast, failureCopiedMessage, copiedTextTheme);
  });
}
