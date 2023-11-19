import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

part 'text_themes.dart';

final mainTheme = ThemeData(
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
    behavior: SnackBarBehavior.floating,
    width: 200,
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(primaryColor),
          textStyle: MaterialStatePropertyAll(TextStyle()),
          foregroundColor: MaterialStatePropertyAll(onPrimaryColor))),
  textTheme: const TextTheme(titleLarge: _titleLarge, titleMedium: _titleMedium, bodyMedium: _bodyMedium),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: primaryColor,
    selectionHandleColor: primaryColor,
  ),
);
