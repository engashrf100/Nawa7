import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: 361.w,
      height: 134.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(55, 96, 249, 0.9),
              Color.fromRGBO(32, 57, 147, 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0x1A3760F9),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                AppAssets.bg00,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "home_banner_title".tr(),
                          textAlign: TextAlign.start,
                          style: AppTextStyles.tajawal18W700.copyWith(
                            color: AppColors.lightWhite,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "home_banner_subtitle".tr(),
                          textAlign: TextAlign.start,
                          style: AppTextStyles.tajawal14W400.copyWith(
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.w),

                  Transform.scale(
                    scaleX: -1,
                    child: Image.asset(
                      AppAssets.arrowUp,
                      width: 24.w,
                      height: 24.h,
                      color: AppColors.primaryWhite,
                      matchTextDirection: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
