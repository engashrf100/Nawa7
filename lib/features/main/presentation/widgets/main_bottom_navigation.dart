import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_cubit.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_state.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<MainTabCubit, MainTabState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom : 8.h),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: theme.border,
           
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        index: 0,
                        isActive: state.currentIndex == 0,
                        activeIcon: AppAssets.houseIconActive,
                        inactiveIcon: AppAssets.houseIcon,
                        label: "home".tr(),
                        onTap: () => context.read<MainTabCubit>().goToHome(),
                      ),
                      _NavItem(
                        index: 1,
                        isActive: state.currentIndex == 1,
                        activeIcon: AppAssets.usersThreeIconActive,
                        inactiveIcon: AppAssets.usersThreeIcon,
                        label: "about_us".tr(),
                        onTap: () => context.read<MainTabCubit>().goToAboutUs(),
                      ),
                      const SizedBox(width: 50), // Space for the middle item
                      _NavItem(
                        index: 3,
                        isActive: state.currentIndex == 3,
                        activeIcon: AppAssets.hospitalIconActive,
                        inactiveIcon: AppAssets.hospitalIcon,
                        label: "branches".tr(),
                        onTap: () => context.read<MainTabCubit>().goToBranches(),
                      ),
                      _NavItem(
                        index: 4,
                        isActive: state.currentIndex == 4,
                        activeIcon: AppAssets.userIconActive,
                        inactiveIcon: AppAssets.userIcon,
                        label: "account".tr(),
                        onTap: () => context.read<MainTabCubit>().goToAccount(),
                      ),
                    ],
                  ),
                  // Middle Floating Item
                  Positioned(
                    top: -30.h,
                    left: MediaQuery.of(context).size.width / 2 - 30.w,
                    child: _MiddleNavItem(
                      index: 2,
                      isActive: state.currentIndex == 2,
                      icon: AppAssets.stethoscopeIcon,
                      onTap: () => context.read<MainTabCubit>().goToDoctors(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool isActive;
  final String activeIcon;
  final String inactiveIcon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    Key? key,
    required this.index,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.lightBlue03;
    final inactiveColor = Theme.of(context).colorScheme.text60;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        width: 57.w,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isActive ? activeIcon : inactiveIcon,
              width: 24.w,
              height: 24.h,
              color: isActive ? activeColor : inactiveColor,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.tajawal12W700.copyWith(
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiddleNavItem extends StatelessWidget {
  final int index;
  final bool isActive;
  final String icon;
  final VoidCallback onTap;

  const _MiddleNavItem({
    Key? key,
    required this.index,
    required this.isActive,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.lightBlue03;
    final inactiveColor = Theme.of(context).colorScheme.text60;


    return GestureDetector(
      onTap: onTap,
      child: Container(
    width: 65.w,
        height: 65.h,
                  padding: EdgeInsets.all(4 .w),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.border ,
          shape: BoxShape.circle,
        
        ),
        child: AnimatedContainer(
    
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? activeColor :inactiveColor,
          shape: BoxShape.circle,
        
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 28.w,
            height: 28.h,
            color: Colors.white,
          ),
        ),
      ),
      ),
    );
  }
}
