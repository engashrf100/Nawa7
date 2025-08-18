import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final ColorScheme colorScheme;
  final bool isWelcome;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.colorScheme,
    this.isWelcome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          _buildImage(),
          SizedBox(height: 40.h),

          // Title
          _buildTitle(),
          SizedBox(height: 15.h),

          // Description
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return page.image!.isNotEmpty
        ? Image.network(
            page.image!,
            width: 250.w,
            height: 300.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 250.w,
                height: 300.h,
                decoration: BoxDecoration(
                  color: colorScheme.container,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.image_not_supported,
                  size: 80.sp,
                  color: colorScheme.text60,
                ),
              );
            },
          )
        : Container(
            width: 250.w,
            height: 300.h,
            decoration: BoxDecoration(
              color: colorScheme.container,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 80.sp,
              color: colorScheme.text60,
            ),
          );
  }

  Widget _buildTitle() {
    return Text(
      page.name!,
      textAlign: TextAlign.center,
      style: AppTextStyles.tajawal22W700.copyWith(color: colorScheme.text100),
    );
  }

  Widget _buildDescription() {
    return Text(
      page.description ?? "",
      textAlign: TextAlign.center,
      style: AppTextStyles.tajawal14W500.copyWith(color: colorScheme.text60),
    );
  }
}
