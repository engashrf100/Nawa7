import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';

import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';

class HomeCardWithButton extends StatelessWidget {
  final VoidCallback onTap;

  const HomeCardWithButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 341.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- العنوان + الأيقونة ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.servicesimg,
                width: 67.w,
                height: 67.h,
                fit: BoxFit.contain,
              ),
              Gap(14.w),

              /// النص
              Expanded(
                child: Text(
                  "home_card_title_bone".tr(),
                  style: AppTextStyles.tajawal20W500.copyWith(
                    color: theme.colorScheme.text80,
                    height: 1.5,
                  ),
                ),
              ),

              /// الأيقونة داخل كونتينر
            ],
          ),
          Gap(20.h),

          /// --- الوصف ---
          Text(
            "home_card_description_bone".tr(),
            style: AppTextStyles.tajawal16W400.copyWith(
              color: theme.colorScheme.text60,
              letterSpacing: 1,
            ),
          ),
          Gap(20.h),

          /// --- زر التفاصيل ---
          AppPrimaryButton(
            title: "home_card_button_details".tr(),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final Benefit benefit;

  const HomeCard({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 341.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// --- العنوان + الأيقونة ---
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomCachedImage(
              imageUrl: benefit.image ?? " ",
              width: 67.w,
              height: 67.h,
              fit: BoxFit.contain,
            ),
          ),
          Gap(16.h),
          Text(
            benefit.name ?? " ",
            style: AppTextStyles.tajawal20W500.copyWith(
              color: theme.colorScheme.text80,
              height: 1.5,
            ),
          ),

          Gap(16.h),

          /// --- الوصف ---
          Text(
            benefit.description ?? " ",
            style: AppTextStyles.tajawal14W400.copyWith(
              color: theme.colorScheme.text60,
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
