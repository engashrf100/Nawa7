import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';

enum CurrentScreen { home, branches, aboutUs, doctors, account }

class HomeHeaderSection extends StatelessWidget {
  final CurrentScreen currentScreen;
  final Function(int)? onTabNavigation; // Callback for tab navigation

  const HomeHeaderSection({
    super.key,
    this.currentScreen = CurrentScreen.home,
    this.onTabNavigation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 361.w,
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Conditionally show user icon (hide on account screen)
          if (currentScreen != CurrentScreen.account)
            GradientIconButton(
              assetPath: AppAssets.userIcon,
              useSvg: true,
              isLeft: false,
              padding: EdgeInsets.all(8.w),
              onTap: () => _handleUserNavigation(context),
            )
          else
            SizedBox(width: 46.w), // Placeholder to maintain layout

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: _buildCenterContent(context, colorScheme),
          ),

          // Right icon - search for most screens, gear for account screen
          GradientIconButton(
            assetPath: currentScreen == CurrentScreen.account
                ? AppAssets.gear
                : AppAssets.search,
            useSvg: true,
            isLeft: true,
            onTap: () => _handleRightIconTap(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context, ColorScheme colorScheme) {
    switch (currentScreen) {
      case CurrentScreen.home:
        return _buildHomeContent(context, colorScheme);
      case CurrentScreen.branches:
        return _buildBranchesContent(colorScheme);
      case CurrentScreen.aboutUs:
        return _buildAboutUsContent(colorScheme);
      case CurrentScreen.doctors:
        return _buildDoctorsContent(colorScheme);
      case CurrentScreen.account:
        return _buildAccountContent(colorScheme);
      default:
        return _buildHomeContent(context, colorScheme);
    }
  }

  Widget _buildHomeContent(BuildContext context, ColorScheme colorScheme) {
    return BlocSelector<TopMainCubit, TopMainState, UserModel?>(
      selector: (state) => state.user,
      builder: (context, user) {
        final country = context.read<SettingsCubit>().state.selectedCountry;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user != null && user.name != null && user.name!.isNotEmpty
                  ? "${"home_welcome".tr()} ${user.name!}"
                  : "home_welcome".tr(),
              style: AppTextStyles.tajawal16W500.copyWith(
                color: colorScheme.text100,
              ),
            ),
            SizedBox(height: 2.h),

            SizedBox(
              width: 200.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "home_subtitle".tr(),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.tajawal14W400.copyWith(
                    color: colorScheme.text80,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBranchesContent(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "branches_header_title".tr(),
          style: AppTextStyles.tajawal16W500.copyWith(
            color: colorScheme.text100,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutUsContent(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "about_us_header_title".tr(),
          style: AppTextStyles.tajawal16W500.copyWith(
            color: colorScheme.text100,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorsContent(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "doctors_header_title".tr(),
          style: AppTextStyles.tajawal16W500.copyWith(
            color: colorScheme.text100,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildAccountContent(ColorScheme colorScheme) {
    return BlocBuilder<TopMainCubit, TopMainState>(
      builder: (context, state) {
        final user = state.user;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user != null && user.name != null && user.name!.isNotEmpty
                  ? user.name!
                  : "account".tr(),
              style: AppTextStyles.tajawal16W500.copyWith(
                color: colorScheme.text100,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              user != null
                  ? "account_header_subtitle_logged_in".tr()
                  : "account_header_subtitle_logged_out".tr(),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.tajawal14W400.copyWith(
                color: colorScheme.text80,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleUserNavigation(BuildContext context) {
    final state = context.read<TopMainCubit>().state;

    // Check if we have a navigation callback
    if (onTabNavigation != null) {
      // Use the callback to navigate to account tab (index 4)
      onTabNavigation!(4);
    } else {
      // Fallback to old behavior if no callback provided
      if (state.user != null) {
        // User is logged in, navigate to user profile
        Navigator.pushNamed(context, AppRoutes.userProfile);
      } else {
        // No user, navigate to login
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }
  }

  void _handleRightIconTap(BuildContext context) {
    if (currentScreen == CurrentScreen.account) {
      // Navigate to user settings screen when gear button is tapped
      Navigator.pushNamed(context, AppRoutes.userSettings);
    } else {
      // Handle search functionality for other screens
      // You can implement search functionality here
      // For now, we'll just show a placeholder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search functionality coming soon'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
