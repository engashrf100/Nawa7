import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool useSvg;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.useSvg = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 341.w,
      height: 53.h,
      decoration: BoxDecoration(
        color: colorScheme.border,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (useSvg)
                      SvgPicture.asset(
                        iconPath,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          iconColor ?? AppColors.lightBlue03,
                          BlendMode.srcIn,
                        ),
                      )
                    else
                      Image.asset(
                        iconPath,
                        width: 20.w,
                        height: 20.h,
                        color: iconColor ?? AppColors.lightBlue03,
                      ),
                    SizedBox(width: 10.w),
                    Text(
                      title,
                      style: AppTextStyles.tajawal14W500.copyWith(
                        color: textColor ?? colorScheme.text80,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  AppAssets.backArrow,
                  width: 16.w,
                  height: 16.h,
                  matchTextDirection: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
