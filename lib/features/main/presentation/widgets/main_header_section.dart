import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_cubit.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_state.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';

class MainHeaderSection extends StatelessWidget {
  const MainHeaderSection({super.key});

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
          // App logo - always visible
          GradientIconButton(
            assetPath: AppAssets.logo,
            useSvg: false,
            isLeft: false,
            padding: EdgeInsets.all(8.w),
            onTap: null,
            preserveColors: true,
          ),

          // Center content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: _buildCenterContent(context, colorScheme),
          ),

          // Right icon based on current tab
          BlocBuilder<MainTabCubit, MainTabState>(
            buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
            builder: (context, state) {
              return _buildRightIcon(context, state.currentIndex);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context, ColorScheme colorScheme) {
    return BlocBuilder<MainTabCubit, MainTabState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        switch (state.currentIndex) {
          case 0:
            return _buildHomeContent(context, colorScheme);
          case 1:
            return _buildAboutUsContent(colorScheme);
          case 2:
            return _buildDoctorsContent(colorScheme);
          case 3:
            return _buildBranchesContent(colorScheme);
          case 4:
            return _buildAccountContent(context, colorScheme);
          default:
            return _buildHomeContent(context, colorScheme);
        }
      },
    );
  }

  Widget _buildRightIcon(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 3: // Branches tab
        return GradientIconButton(
          assetPath: AppAssets.search,
          useSvg: true,
          isLeft: true,
          onTap: () => _handleSearchTap(context),
        );
      case 4: // Account tab
        return GradientIconButton(
          assetPath: AppAssets.gear,
          useSvg: true,
          isLeft: true,
          onTap: () => _handleSettingsTap(context),
        );
      default:
        return SizedBox(width: 46.w); // Placeholder for other tabs
    }
  }

  Widget _buildHomeContent(BuildContext context, ColorScheme colorScheme) {
    return BlocSelector<TopMainCubit, TopMainState, UserModel?>(
      selector: (state) => state.user,
      builder: (context, user) {
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
              child: Text(
                  "home_subtitle".tr(),
                  textAlign: TextAlign.start,
                  style: AppTextStyles.tajawal14W400.copyWith(
                    color: colorScheme.text80,
                  
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

  Widget _buildAccountContent(BuildContext context, ColorScheme colorScheme) {
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

  void _handleSearchTap(BuildContext context) {
    // Get branches data from HomeCubit and navigate to search screen
    final homeState = context.read<HomeCubit>().state;
    final branches = homeState.allBranches;
    
    Navigator.pushNamed(
      context,
      '/search',
      arguments: {'initialBranches': branches},
    );
  }

  void _handleSettingsTap(BuildContext context) {
    // Navigate to user settings
    Navigator.pushNamed(context, AppRoutes.userSettings);
  }
}
