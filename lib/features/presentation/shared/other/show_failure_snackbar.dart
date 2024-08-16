import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoasts.dart';
import 'package:spotify_downloader/generated/l10n.dart';

void showFailureSnackBar(BuildContext innerContext, String message, {Duration duration = const Duration(seconds: 2)}) {
  showSmallTextSnackBar(innerContext, message, duration: duration, onTap: () {
    final ftoast = FtoastAccessor.of(innerContext).fToast;
    ftoast.removeCustomToast();
    Clipboard.setData(ClipboardData(text: message));

    showBigTextSnackBar(innerContext, S.of(innerContext).failureCopied);
  });
}
