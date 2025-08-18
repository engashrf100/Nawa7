import 'package:flutter/material.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightBlue00,
    scaffoldBackgroundColor: AppColors.lightWhite,

    textTheme: TextTheme(
      titleLarge: AppTextStyles.lightTitle,
      bodyMedium: AppTextStyles.lightBody,
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBlue00,
    scaffoldBackgroundColor: AppColors.darkWhite,
    textTheme: TextTheme(
      titleLarge: AppTextStyles.darkTitle,
      bodyMedium: AppTextStyles.darkBody,
    ),
  );
}
