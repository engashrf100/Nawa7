import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';

class GradientIconButton extends StatelessWidget {
  final bool useSvg;
  final String assetPath;
  final bool isLeft;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  const GradientIconButton({
    Key? key,
    required this.assetPath,
    this.useSvg = false,
    this.isLeft = true,
    this.onTap,
    this.padding,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 54.w,
        height: height ?? 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
            end: isLeft ? Alignment.topLeft : Alignment.topRight,
            colors: [colorScheme.white, colorScheme.homeBg, colorScheme.homeBg],
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(15.w),
          child: useSvg
              ? SvgPicture.asset(
                  assetPath,
                  color: colorScheme.onBackground.withOpacity(0.8),
                  width: 24.w,
                  height: 24.h,
                )
              : Image.asset(
                  assetPath,
                  color: colorScheme.onBackground.withOpacity(0.8),
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
