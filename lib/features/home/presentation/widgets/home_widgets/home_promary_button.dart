import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class AppPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? letterSpacing;
  final TextStyle? textStyle;

  const AppPrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.letterSpacing,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: Container(
        width: width ?? 301.w,
        height: height ?? 49.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.blue02, // افتراضي: الأزرق
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
        child: Center(
          child: Text(
            title,
            style:
                textStyle ??
                AppTextStyles.tajawal14W700.copyWith(
                  color:
                      textColor ?? theme.colorScheme.textWhite, // افتراضي: أبيض
                  letterSpacing: letterSpacing ?? 1.1.w,
                ),
          ),
        ),
      ),
    );
  }
}
