import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';

class AllServicesButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AllServicesButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 341.w,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: theme.border, // Pure White
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// النص
            Container(
              width: 40.w,
              height: 40.h,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.homeBg,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Transform.scale(
                scaleX: -1,
                child: SvgPicture.asset(
                  AppAssets.arrow,
                  width: 15.w,
                  height: 12.h,

                  matchTextDirection: true,
                ),
              ),
            ),
            SizedBox(width: 10.w),

            /// الأيقونة داخل حاوية دائرية
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.tajawal14W500.copyWith(color: theme.text100),
            ),
          ],
        ),
      ),
    );
  }
}
