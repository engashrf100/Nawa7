import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showViewAll; // ✅ باراميتر جديد

  const AppSectionHeader({
    super.key,
    required this.title,
    required this.onTap,
    this.showViewAll = true, // ✅ القيمة الافتراضية: يظهر النص والسهم
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 341.w,
        height: 66.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.border,
              theme.colorScheme.border,
              theme.colorScheme.border,
              theme.colorScheme.border,
              theme.colorScheme.border,
              theme.colorScheme.container,
            ],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ العنوان الرئيسي
            Text(
              title,

              style: AppTextStyles.tajawal22W500.copyWith(
                color: theme.colorScheme.text100,
              ),
            ),

            /// ✅ السهم والنص "عرض الكل" يظهر فقط إذا showViewAll = true
            if (showViewAll)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "home_view_all".tr(),
                    style: AppTextStyles.tajawal14W400.copyWith(
                      color: theme.colorScheme.text60,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Transform.scale(
                    scaleX: -1,
                    child: SvgPicture.asset(
                      AppAssets.arrow,
                      width: 14.w,
                      height: 14.h,
                      color: AppColors.lightBlue02,
                      alignment: Alignment.topCenter,
                      matchTextDirection: true,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
