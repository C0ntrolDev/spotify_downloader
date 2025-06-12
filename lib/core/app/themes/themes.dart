import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

part 'text_themes.dart';

final mainTheme = ThemeData(
  cardTheme: const CardTheme(color: surfaceColor),
  scrollbarTheme: ScrollbarThemeData(
      interactive: true,
      thumbVisibility: const WidgetStatePropertyAll(true),
      radius: const Radius.circular(10),
      crossAxisMargin: 5,
      mainAxisMargin: 5,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged)) {
          return primaryColor;
        } else {
          return onBackgroundSecondaryColor;
        }
      })),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.selected)) {
        return onBackgroundSecondaryColor;
      } else {
        return null;
      }
    }),
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.selected)) {
        return onBackgroundThirdRateColor;
      } else {
        return null;
      }
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.selected)) {
        return onBackgroundThirdRateColor;
      } else {
        return Colors.transparent;
      }
    }),
  ),
  scaffoldBackgroundColor: backgroundColor,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
    TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder()
  }),
  dialogBackgroundColor: dialogColor,
  snackBarTheme: const SnackBarThemeData(
    elevation: 0,
    backgroundColor: dialogColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    behavior: SnackBarBehavior.floating,
    width: 200,
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryColor),
          textStyle: WidgetStatePropertyAll(TextStyle()),
          foregroundColor: WidgetStatePropertyAll(onPrimaryColor))),
  textTheme: const TextTheme(
      titleLarge: _titleLarge,
      titleMedium: _titleMedium,
      titleSmall: _titleSmall,
      bodyLarge: _bodyLarge,
      bodyMedium: _bodyMedium,
      bodySmall: _bodySmall,
      labelLarge: _labelLarge,
      labelMedium: _labelMedium,
      labelSmall: _labelSmall),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: primaryColor,
    selectionHandleColor: primaryColor,
  ),
);

void initTheme() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
}

class TransitionsBuildersExtension {
  static const fadeInWithBackground = _fadeInWithBackground;

  static Widget _fadeInWithBackground(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
          opacity: animation, child: Container(constraints: const BoxConstraints.expand(), color: backgroundColor));
    } else {
      return Container(
        constraints: const BoxConstraints.expand(),
        color: backgroundColor,
        child: FadeTransition(opacity: animation, child: child),
      );
    }
  }
}

class ClampingScrollPhysicsBehavior extends ScrollBehavior {
  const ClampingScrollPhysicsBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
