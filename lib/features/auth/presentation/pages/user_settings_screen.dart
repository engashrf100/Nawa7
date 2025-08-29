import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/base_bottom_sheet.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.homeBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Container(
                width: 361.w,
                height: 103.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Gap(16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientIconButton(
                          assetPath: AppAssets.backArrow,
                          useSvg: true, 
                          isLeft: false,
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(8.w),
                          onTap: () => Navigator.pop(context),
                        ),
                        Text(
                          "user_settings_title".tr(),
                          style: AppTextStyles.tajawal16W500.copyWith(
                            color: colorScheme.text100,
                          ),
                        ),
                        SizedBox(width: 40.w),
                      ],
                    ),
                    Gap(16.h),
                  ],
                ),
              ),

              // Main Content
              AppCard(
                child: Column(
                  children: [
                    _buildLanguageItem(context, locale, colorScheme),
                    Gap(16.h),

                    _buildThemeSwitchItem(context, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitchItem(BuildContext context, ColorScheme colorScheme) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.themeMode == AppThemeMode.dark;

        return Container(
          width: 341.w,
          height: 53.h,
          decoration: BoxDecoration(
            color: colorScheme.border,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colorScheme.border, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side with icon and text
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.moon0,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.lightBlue03,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          "dark_mode".tr(),
                          style: AppTextStyles.tajawal14W500.copyWith(
                            color: colorScheme.text80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side with animated switch
                _buildAnimatedThemeSwitch(context, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedThemeSwitch(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsCubit>().toggleTheme();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 51.w,
        height: 31.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.lightBlue03 : AppColors.lightGray00,
          borderRadius: BorderRadius.circular(31.h / 2),
        ),
        child: Stack(
          children: [
            // Animated knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 27.w,
                height: 27.h,
                margin: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(27.h / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    String locale,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: 341.w,
      height: 53.h,
      decoration: BoxDecoration(
        color: colorScheme.border,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageBottomSheet(context),
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.global,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.lightBlue03,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "language".tr(),
                      style: AppTextStyles.tajawal14W500.copyWith(
                        color: colorScheme.text80,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Language flag
                    SvgPicture.asset(
                      locale == 'ar' ? AppAssets.ar : AppAssets.en,
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 10.w),

                    Icon(  Icons.arrow_forward_ios,
                color: AppColors.lightBlue03,
                size: 16.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguageBottomSheet(),
    );
  }
}

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  void _showChangeLanguageDialog(BuildContext context, String newLocale) {
    final languageName = newLocale == 'en' ? 'English' : 'العربية';

    DialogService.confirm(
      context,
      title: "change_language_title".tr(),
      subtitle: "change_language_subtitle".tr(args: [languageName]),
      onConfirm: () {
        // Close dialog first
        Navigator.of(context, rootNavigator: true).pop();

        // Change language
        context.setLocale(Locale(newLocale));

        // Close bottom sheet
        Navigator.of(context, rootNavigator: true).pop();

        // Show success feedback
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return BaseBottomSheet(
      children: [
        // Language options
        SelectableRowItem(
          label: "english".tr(),
          isSvg: true,
          isSelected: currentLocale == "en",
          imageUrl: AppAssets.en,
          onTap: () {
            if (currentLocale != "en") {
              _showChangeLanguageDialog(context, "en");
            }
          },
        ),
        Gap(10.h),
        SelectableRowItem(
          label: "arabic".tr(),
          isSvg: true,
          isSelected: currentLocale == "ar",
          imageUrl: AppAssets.ar,
          onTap: () {
            if (currentLocale != "ar") {
              _showChangeLanguageDialog(context, "ar");
            }
          },
        ),
        Gap(16.h),
      ],
    );
  }
}
