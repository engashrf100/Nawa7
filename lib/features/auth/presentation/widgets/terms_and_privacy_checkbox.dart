import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class TermsAndPrivacyCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTermsTap;

  const TermsAndPrivacyCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<bool>(
      initialValue: isChecked,
      validator: (value) {
        if (!isChecked) {
          return 'please_accept_policies'.tr();
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 42.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      onChanged(value ?? false);
                      field.didChange(value);
                    },
                    side: BorderSide(color: AppColors.lightBlue03, width: 1.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    activeColor: AppColors.lightBlue03,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTermsTap,
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.tajawal14W400.copyWith(
                            color: theme.colorScheme.text100,
                            fontSize: 14.sp,
                            height: 1.5,
                            letterSpacing: 0.02,
                          ),
                          children: [
                            TextSpan(text: "agree_terms".tr()),
                            TextSpan(
                              text: "terms_and_privacy".tr(), // Combined text
                              style: const TextStyle(
                                color: AppColors.lightBlue03,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 4.h, right: 12.w),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}
