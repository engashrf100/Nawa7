import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/home/presentation/widgets/country_widgets/country_bottom_sheet.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';

class PhoneFieldWithCountryPicker extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(Country)? onCountrySelected;
  final List<String>? errorMessages;

  const PhoneFieldWithCountryPicker({
    Key? key,
    required this.controller,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.onCountrySelected,
    this.errorMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      errorMessages: errorMessages,
      hintText: hintText ?? 'phone_number'.tr(),
      keyboardType: TextInputType.phone,
      suffixIcon: _CountryPickerSuffix(
        onTap: () => _showCountryPicker(context),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const CountryBottomSheet(),
    );
  }
}

class _CountryPickerSuffix extends StatelessWidget {
  final VoidCallback onTap;

  const _CountryPickerSuffix({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final selectedCountry = context
            .read<SettingsCubit>()
            .state
            .selectedCountry;
        final country = selectedCountry;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SizedBox(
              height: 24.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (country != null) ...[
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Text(
                        country!.countryCode ?? "+20",
                        style: AppTextStyles.tajawal12W400.copyWith(
                          color: colorScheme.text100,
                          letterSpacing: 0.02.w,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 20.sp,
                      color: colorScheme.text40,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: CustomCachedImage(
                        imageUrl: country!.flag!,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ] else ...[
                    Text(
                      "country_code_selection".tr(),
                      style: AppTextStyles.tajawal12W400.copyWith(
                        color: colorScheme.text100,
                        letterSpacing: 0.02.w,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 20.sp,
                      color: colorScheme.text40,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
