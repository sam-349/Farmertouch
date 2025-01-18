import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 24, color: ColorsUtil.onPrimary, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(
      fontSize: 18,
      color: ColorsUtil.onPrimary,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      color: ColorsUtil.onPrimary.withOpacity(0.5),
    ),
    displayLarge: TextStyle(
      fontSize: 18,
      color: ColorsUtil.txtColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: 14,
      color: ColorsUtil.onPrimary,
    ),
  ),
  // elevatedButtonTheme: ElevatedButtonThemeData
);
