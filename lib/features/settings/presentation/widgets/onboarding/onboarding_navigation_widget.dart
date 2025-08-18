import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_state.dart';

class OnboardingNavigationWidget extends StatelessWidget {
  final OnboardingState state;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onLogin;

  const OnboardingNavigationWidget({
    super.key,
    required this.state,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return state.when(
      loaded: (data, currentIndex) {
        final totalPages = data.pages!.length;
        final isLastPage = currentIndex == totalPages - 1;
        final isFirstPage = currentIndex == 0;

        final double progressValue = (totalPages > 0)
            ? (currentIndex + 1) / totalPages
            : 0.0; // fallback to 0% if no pages

        return Column(
          children: [
            // Dots Indicator
            if (currentIndex > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages - 1, (index) {
                    final isActive = (currentIndex - 1) == index;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: isActive ? 18.w : 5.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: isActive
                            ? colorScheme.blue02
                            : const Color(0xFFD1D6E5),
                      ),
                    );
                  }),
                ),
              ),

            // Navigation Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: Column(
                children: [
                  // Next/Complete Button
                  _buildNavigationButton(
                    isLastPage: isLastPage,
                    progressValue: progressValue,
                    colorScheme: colorScheme,
                    onTap: isLastPage ? onSkip : onNext,
                  ),

                  // Login Link (only on first page)
                  if (isFirstPage)
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: _buildLoginLink(colorScheme),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      initial: () => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      error: (_) => const SizedBox.shrink(),
    );
  }

  Widget _buildNavigationButton({
    required bool isLastPage,
    required double progressValue,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: "onb_next_btn",
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final flipAnimation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );
                final isReversing = flightDirection == HeroFlightDirection.pop;
                final angle =
                    (isReversing ? -1 : 1) * flipAnimation.value * 3.1416;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: toHeroContext.widget,
                );
              },
            );
          },
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 70.w,
          height: 70.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70.w,
                height: 70.h,
                child: CircularProgressIndicator(
                  value: progressValue.isFinite && !progressValue.isNaN
                      ? progressValue
                      : 0.0,
                  strokeWidth: 3.w,
                  color: colorScheme.blue02,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.blue02,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  isLastPage ? Icons.check : Icons.arrow_forward,
                  color: colorScheme.white,
                  size: 28.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onLogin,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "have_account_prefix".tr() + " ",
              style: AppTextStyles.tajawal12W400.copyWith(
                color: colorScheme.text100,
              ),
            ),
            TextSpan(
              text: "login_now".tr(),
              style: AppTextStyles.tajawal12W700.copyWith(
                color: colorScheme.blue02,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
