import 'package:flutter/material.dart';

class AppColors {
  // ---------- ✅ BORDERS ----------
  static const Color lightBorder = Colors.white;
  static const Color darkBorder = Color(0xFF222224);

  static const Color border00 = Color(0xFFEFF4FF); // light bg border
  static const Color border01 = Color(0xFFE8E9EB); // light gray border

  // ---------- ✅ PRIMARY / CONTAINER ----------
  static const Color lightContainer = Color(0xFFE0E8FF);
  static const Color darkContainer = Color(0xFF1E2230);

  static const Color primaryWhite = Color(0xFFE3E7FA);
  static const Color primaryBlack = Color(0xFF000000);

  static const Color dark20 = Color(0xFFBABCC1);

  // ---------- ✅ BLUES ----------
  static const Color lightBlue00 = Color(0xFF264DDD);
  static const Color darkBlue00 = Color.fromARGB(255, 4, 20, 82);

  static const Color lightBlue01 = Color(0xFF203993);
  static const Color darkBlue01 = Color.fromARGB(255, 13, 24, 66);

  static const Color lightBlue02 = Color(0xFF3760F9);
  static const Color darkBlue02 = Color(0xFF6186FF);

  static const Color lightBlue03 = Color(
    0xFF597AF4,
  ); // optional (no dark match)

  // ---------- ✅ TEXT ----------
  // Light Texts
  static const Color lightText100 = Color(0xFF17223B);
  static const Color lightText80 = Color(0xFF3F485C);
  static const Color lightText60 = Color(0xFF686E7D);
  static const Color lightText40 = Color(0xFF9196A0);

  // Dark Texts
  static const Color darkText100 = Color(0xFFFFFFFF);
  static const Color darkText80 = Color(0xFFEBEDF5);
  static const Color darkText60 = Color(0xFFB0B3B8);

  // White Texts (special cases)
  static const Color lightWhite = Colors.white;
  static const Color darkWhiteText = Color(0xFF0F0F0F);

  // ---------- ✅ GRAYS ----------
  static const Color lightGray00 = Color(0xFFD7D8D9);
  static const Color lightGray01 = Color(0xFFF4F5F7);
  static const Color lightGray03 = Color(0xFFEDEEF0);

  static const Color darkGray03 = Color(0xFF323236);

  // ---------- ✅ BACKGROUNDS ----------
  static const Color darkWhite = Color(0xFF000000); // dark background
  static const Color darkHome = Color(0xFF18181A);

  // ---------- ✅ NEW DIALOG COLORS ----------
  static const Color successBg = Color(0x1A27AE60);
  static const Color success = Color(0xFF27AE60);

  static const Color errorBg = Color(0x1AFF5F56);
  static const Color error = Color(0xFFFF5F56);

  static const Color dialogCloseBg = Color(0xFFF4F5F7);
}

/// ---------- ✅ EXTENSION TO GET COLORS BASED ON BRIGHTNESS ----------
extension AppColorScheme on ColorScheme {
  // --- Blues ---
  Color get blue00 => brightness == Brightness.light
      ? AppColors.lightBlue00
      : AppColors.darkBlue00;

  Color get blue01 => brightness == Brightness.light
      ? AppColors.lightBlue01
      : AppColors.darkBlue01;

  Color get blue02 => brightness == Brightness.light
      ? AppColors.lightBlue02
      : AppColors.darkBlue02;

  // --- Borders & Containers ---
  Color get border => brightness == Brightness.light
      ? AppColors.lightBorder
      : AppColors.darkBorder;

  Color get container => brightness == Brightness.light
      ? AppColors.lightContainer
      : AppColors.darkContainer;

  Color get greyStroke => brightness == Brightness.light
      ? AppColors.lightGray03
      : AppColors.darkGray03;

  // --- Texts ---
  Color get text100 => brightness == Brightness.light
      ? AppColors.lightText100
      : AppColors.darkText100;

  Color get text80 => brightness == Brightness.light
      ? AppColors.lightText80
      : AppColors.darkText80;

  Color get text60 => brightness == Brightness.light
      ? AppColors.lightText60
      : AppColors.darkText60;

  Color get text40 => brightness == Brightness.light
      ? AppColors.lightText40
      : AppColors.darkText100; // ⚠️ consider making darkText40 if needed

  Color get textWhite => brightness == Brightness.light
      ? AppColors.lightWhite
      : AppColors.darkWhiteText;

  // --- Backgrounds ---
  Color get white => brightness == Brightness.light
      ? AppColors.lightWhite
      : AppColors.darkWhite;

  Color get homeBg =>
      brightness == Brightness.light ? AppColors.border00 : AppColors.darkHome;

  Color get gray00 =>
      AppColors.lightGray00; // same for light/dark (no dark version)

  // --- Additional properties for the branches screen ---
  Color get surface => brightness == Brightness.light
      ? AppColors.lightGray01
      : AppColors.darkGray03;

  Color get outline => brightness == Brightness.light
      ? AppColors.lightGray00
      : AppColors.darkGray03;
}
