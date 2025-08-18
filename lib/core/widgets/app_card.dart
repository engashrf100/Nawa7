import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    super.key,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.gradient,
    this.boxShadow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      padding: padding ?? EdgeInsets.all(10.w),
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: color,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.border,
          width: 1,
        ),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
