import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';

class ChooseThemeScreen extends StatefulWidget {
  const ChooseThemeScreen({Key? key}) : super(key: key);

  @override
  State<ChooseThemeScreen> createState() => _ChooseThemeScreenState();
}

class _ChooseThemeScreenState extends State<ChooseThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BackgroundWidget00(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 40.h),
                child: const BackButton00(),
              ),
              Gap(20.h),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  AppAssets.themeImg,
                  width: 334.w,
                  height: 351.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "choose_theme_title".tr(),
                      style: AppTextStyles.tajawal22W700.copyWith(
                        color: theme.colorScheme.text100,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Gap(16.h),
                    Container(
                      width: 329.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.border00, width: 1),
                      ),
                      child: Container(
                        width: 309.w,
                        height: 63.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.border00,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.moon,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                Gap(10.w),
                                Text(
                                  "dark_mode".tr(),
                                  style: AppTextStyles.tajawal14W500.copyWith(
                                    color: AppColors.darkBorder,
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, state) {
                                final isDark =
                                    state.themeMode == AppThemeMode.dark;

                                return _buildAnimatedThemeSwitch(
                                  context,
                                  isDark,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(120.h),
                    Center(
                      child: AppPrimaryButton(
                        title: "confirm".tr(),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.onBoardig,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
}
