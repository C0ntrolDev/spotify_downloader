import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';

part 'text_themes.dart';

final mainTheme = ThemeData(
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
