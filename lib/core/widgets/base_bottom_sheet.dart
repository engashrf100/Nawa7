import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';

class BaseBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onClose;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;

  const BaseBottomSheet({
    Key? key,
    required this.children,
    this.onClose,
    this.maxHeight,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxHeight ?? 600.h),
        padding: padding ?? EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.homeBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              SizedBox(height: 10.h),
              _buildCloseButton(context),
              SizedBox(height: 20.h),
              ...children,
              SizedBox(height: 22.h),
              _buildHandle(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 51.w,
        height: 3.h,
        decoration: BoxDecoration(
          color: AppColors.dark20,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 30.w,
          height: 30.w,
          padding: EdgeInsets.all(6.w),
          decoration: const BoxDecoration(
            color: AppColors.border01,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            AppAssets.closeIcon,
            width: 18.w,
            height: 18.h,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.text60,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
