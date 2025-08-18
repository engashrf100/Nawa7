import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_state.dart';

class OnboardingHeaderWidget extends StatelessWidget {
  final OnboardingState state;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingHeaderWidget({
    super.key,
    required this.state,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      loaded: (data, currentIndex) {
        final totalPages = data.pages?.length;
        final isLastPage = currentIndex == totalPages! - 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button (only show if not on first page)
            if (currentIndex > 0) BackButton00(onTap: onBack),

            const Spacer(),

            // Skip Button (only show if not on last page)
            if (!isLastPage) _buildSkipButton(context),
          ],
        );
      },
      initial: () => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      error: (_) => const SizedBox.shrink(),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onSkip,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: Text(
          'skip'.tr(),
          style: AppTextStyles.tajawal16W500.copyWith(
            color: colorScheme.text40,
          ),
        ),
      ),
    );
  }
}
