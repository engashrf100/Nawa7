import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String iconPath;
  final bool isPassword;
  final bool isPhone;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<String>? errorMessages;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.iconPath,
    this.isPassword = false,
    this.isPhone = false,
    this.validator,
    this.keyboardType,
    this.errorMessages,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.tajawal16W500.copyWith(
                color: colorScheme.text80,
              ),
            ),

            SvgPicture.asset(AppAssets.edit, width: 20.w, height: 20.h),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: 301.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: colorScheme.homeBg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryWhite),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType:
                keyboardType ??
                (isPhone ? TextInputType.phone : TextInputType.text),
            style: AppTextStyles.tajawal16W400.copyWith(
              color: colorScheme.text100,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            validator:
                validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return "${label} ${"is_required".tr()}";
                  }
                  return null;
                },
          ),
        ),

        if (errorMessages != null && errorMessages!.isNotEmpty) ...[
          SizedBox(height: 4.h),
          ...errorMessages!.map(
            (error) => Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                "• $error",
                style: AppTextStyles.tajawal12W400.copyWith(
                  color: Colors.red,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
