import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class ErrorScreen extends StatefulWidget {
  final String? errorMessage;
  final VoidCallback onRetry;
  final bool isNoInternet;

  const ErrorScreen({
    super.key,
    this.errorMessage,
    required this.onRetry,
    this.isNoInternet = false,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.locale.languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Icon with Animation
          _buildErrorIcon(theme),
          Gap(32.h),

          // Error Title
          _buildErrorTitle(theme, isArabic),
          Gap(16.h),

          // Error Subtitle
          _buildErrorSubtitle(theme, isArabic),
          Gap(32.h),

          // Error Details (if available)
          if (widget.errorMessage != null) ...[
            _buildErrorDetails(theme),
            Gap(32.h),
          ],

          // Retry Button
          _buildRetryButton(theme, isArabic),
        ],
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.container,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.error, width: 3.w),
      ),
      child: Icon(
        widget.isNoInternet ? Icons.wifi_off : Icons.error_outline,
        size: 60.sp,
        color: AppColors.error,
      ),
    );
  }

  Widget _buildErrorTitle(ThemeData theme, bool isArabic) {
    return Text(
      widget.isNoInternet
          ? 'no_internet_error'.tr()
          : 'error_screen_title'.tr(),
      style: AppTextStyles.tajawal22W700.copyWith(
        color: theme.colorScheme.text100,
        fontSize: 24.sp,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorSubtitle(ThemeData theme, bool isArabic) {
    return Text(
      'error_screen_subtitle'.tr(),
      style: AppTextStyles.tajawal16W400.copyWith(
        color: theme.colorScheme.text80,
        fontSize: 16.sp,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorDetails(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.error, size: 20.sp),
              Gap(8.w),
              Text(
                'error_details'.tr(),
                style: AppTextStyles.tajawal14W700.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            widget.errorMessage!,
            style: AppTextStyles.tajawal14W400.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(ThemeData theme, bool isArabic) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          // Add button press animation
          _animationController.reverse().then((_) {
            widget.onRetry();
            _animationController.forward();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightBlue03,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 20.sp, color: Colors.white),
            Gap(8.w),
            Text(
              'retry_button'.tr(),
              style: AppTextStyles.tajawal16W500.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
