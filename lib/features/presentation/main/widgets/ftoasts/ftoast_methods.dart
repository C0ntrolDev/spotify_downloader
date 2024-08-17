import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify_downloader/core/app/themes/theme_consts.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/ftoasts/ftoast_acessor.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/orientated_navigation_bar/orientated_navigation_bar_acessor.dart';

void showBigTextSnackBar(BuildContext innerContext, String message,
    {Duration duration = const Duration(seconds: 2), void Function()? onTap}) {
  final fToast = FtoastAccessor.of(innerContext).fToast;
  showSnackBarWithFToastAndTextStyle(fToast, message, Theme.of(innerContext).textTheme.bodyMedium,
      duration: duration, onTap: onTap);
}

void showSmallTextSnackBar(BuildContext innerContext, String message,
    {Duration duration = const Duration(seconds: 2), void Function()? onTap}) {
  final fToast = FtoastAccessor.of(innerContext).fToast;
  showSnackBarWithFToastAndTextStyle(fToast, message, Theme.of(innerContext).textTheme.labelMedium,
      duration: duration, onTap: onTap);
}

void showSnackBarWithFToastAndTextStyle(FToast fToast, String message, TextStyle? textStyle,
    {Duration duration = const Duration(seconds: 2), void Function()? onTap}) {
  fToast.showToast(
      fadeDuration: const Duration(milliseconds: 150),
      toastDuration: duration,
      gravity: ToastGravity.BOTTOM,
      positionedToastBuilder: (context, child) {
        return Positioned(bottom: 0, left: 0, right: 0, child: child);
      },
      child: Builder(builder: (overlayContext) {
        final mediaQuery = MediaQuery.of(overlayContext);
        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: (OrientatedNavigationBarAcessor.maybeOf(overlayContext)?.expandedHeight ?? 0) + 10,
                top: 10,
                left: horizontalPadding,
                right: horizontalPadding),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: mediaQuery.size.width / 2,
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: dialogColor),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTapUp: (details) => onTap?.call(),
                  child: LayoutBuilder(builder: (context, constrains) {
                    final fontHeight =
                        mediaQuery.textScaler.scale((textStyle?.fontSize ?? 16)) * (textStyle?.height ?? 1);

                    return Text(message,
                        style: textStyle,
                        maxLines: (constrains.maxHeight / fontHeight).floor(),
                        textAlign: TextAlign.center);
                  }),
                ),
              ),
            ),
          ),
        );
      }));
}
