import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle urbanist36W500 = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 36.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.03.w,
    height: 1.5.h,
  );
  static TextStyle tajawal18W700 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
  );
  static TextStyle get tajawal22W500 => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    height: 1.2, // 120%
    letterSpacing: 0,
  );
  static final tajawal20W500 = TextStyle(
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    height: 1.5,
  );

  static final tajawal16W400 = TextStyle(
    fontFamily: 'Tajawal',
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1.5,
    letterSpacing: 1,
  );

  static TextStyle tajawal14W400 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.02.w,
  );

  static TextStyle tajawal22W700 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle tajawal32W600 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );
  // 12px Regular
  static TextStyle tajawal12W400 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.02.w,
  );

  // 12px Bold
  static TextStyle tajawal12W700 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0.0,
  );
  static TextStyle tajawal12W500 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.0,
  );
  static TextStyle tajawal14W700 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    height: 1.5.h,
    letterSpacing: 0.02.w,
  );

  static TextStyle tajawal14W500 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.02,
  );

  static TextStyle tajawal16W500 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.5, // 150%
    letterSpacing: 0.01.w, // 1%
  );

  // Light Theme
  static const TextStyle lightTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle lightBody = TextStyle(fontSize: 16);

  // Dark Theme
  static const TextStyle darkTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle darkBody = TextStyle(fontSize: 16);
}
