import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/core/const/app_assets.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: theme.border,
          boxShadow: [
            BoxShadow(
              color: theme.text100.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    index: 0,
                    isActive: widget.currentIndex == 0,
                    activeIcon: AppAssets.houseIconActive,
                    inactiveIcon: AppAssets.houseIcon,
                    label: "home".tr(),
                    onTap: widget.onTap,
                  ),
                  _NavItem(
                    index: 1,
                    isActive: widget.currentIndex == 1,
                    activeIcon: AppAssets.usersThreeIconActive,
                    inactiveIcon: AppAssets.usersThreeIcon,
                    label: "about_us".tr(),
                    onTap: widget.onTap,
                  ),
                  const SizedBox(width: 50), // Space for the middle item
                  _NavItem(
                    index: 3,
                    isActive: widget.currentIndex == 3,
                    activeIcon: AppAssets.hospitalIconActive,
                    inactiveIcon: AppAssets.hospitalIcon,
                    label: "branches".tr(),
                    onTap: widget.onTap,
                  ),
                  _NavItem(
                    index: 4,
                    isActive: widget.currentIndex == 4,
                    activeIcon: AppAssets.userIconActive,
                    inactiveIcon: AppAssets.userIcon,
                    label: "account".tr(),
                    onTap: widget.onTap,
                  ),
                ],
              ),
              // Middle Floating Item
              Positioned(
                top: -30.h,
                left: MediaQuery.of(context).size.width / 2 - 30.w,
                child: _MiddleNavItem(
                  index: 2,
                  isActive: widget.currentIndex == 2,
                  icon: AppAssets.stethoscopeIcon,
                  onTap: widget.onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool isActive;
  final String activeIcon;
  final String inactiveIcon;
  final String label;
  final ValueChanged<int> onTap;

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
      onTap: () => onTap(index),
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
  final ValueChanged<int> onTap;

  const _MiddleNavItem({
    Key? key,
    required this.index,
    required this.isActive,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 68.w,
        height: 68.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.border,
          borderRadius: BorderRadius.circular(100),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: theme.text100,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 28.w,
              height: 28.h,
              color: theme.border,
            ),
          ),
        ),
      ),
    );
  }
}
