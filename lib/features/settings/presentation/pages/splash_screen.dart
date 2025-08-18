import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/loading_spinner.dart';

import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    // Start animations
    _startAnimations();

    // Handle navigation after delay
    Timer(const Duration(seconds: 3), _handleNavigation);
  }

  void _startAnimations() async {
    // Start fade animation
    await _fadeController.forward();

    // Start slide animation for text
    await _slideController.forward();

    // Start scale animation for loading spinner
    _scaleController.forward();
  }

  void _handleNavigation() async {
    final status = context.read<SettingsCubit>().state.flowStatus;

    switch (status) {
      case AppFlowStatus.choosingLang:
        Navigator.pushReplacementNamed(context, AppRoutes.lang);
        break;
      case AppFlowStatus.onboarding:
        Navigator.pushReplacementNamed(context, AppRoutes.onBoardig);
        break;
      case AppFlowStatus.home:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.lang);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightBlue00, // Use light blue directly
              AppColors.lightBlue01, // Use light blue directly
            ],
          ),
        ),
        child: Column(
          children: [
            // Background image with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                AppAssets.bg00,
                width: double.infinity,
                height: 195.h,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
              ),
            ),
            Gap(60.h),

            // Nawah text with slide and fade animations
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Nawah".tr(),
                  style: AppTextStyles.urbanist36W500.copyWith(
                    color: AppColors.lightWhite, // Use light white directly
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Gap(30.h),

            // Loading spinner with scale animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: SizedBox(
                width: 48.w,
                height: 48.h,
                child: LoadingSpinner(
                  activeColor: AppColors.lightBlue02, // Use light blue directly
                  inactiveColor:
                      AppColors.lightGray00, // Use light gray directly
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
