import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/widgets/profile_menu_item.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      body: BlocBuilder<TopMainCubit, TopMainState>(
        builder: (context, state) {
          final user = state.user;

          if (user != null) {
            return _buildLoggedInContent(context, theme, user);
          } else {
            return _buildLoggedOutContent(context, theme);
          }
        },
      ),
    );
  }

  Widget _buildLoggedInContent(
    BuildContext context,
    ThemeData theme,
    dynamic user,
  ) {
    return Column(
      children: [
        // Main Content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              children: [
                // Theme & Language Section

                // Services Section
                AppCard(
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        title: "my_account".tr(),
                        iconPath: AppAssets.personRounded,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.userAccount);
                        },
                      ),
                      Gap(8.h),
                      ProfileMenuItem(
                        title: "request_consultation".tr(),
                        iconPath: AppAssets.messagePlusFill,
                        onTap: () {
                          // Navigate to request consultation
                        },
                      ),
                      Gap(8.h),
                      ProfileMenuItem(
                        title: "my_consultations".tr(),
                        iconPath: AppAssets.messageCheckFill,
                        onTap: () {
                          // Navigate to my consultations
                        },
                      ),
                      Gap(8.h),
                      ProfileMenuItem(
                        title: "book_now".tr(),
                        iconPath: AppAssets.calendarPlusFill,
                        onTap: () {
                          // Navigate to book now
                        },
                      ),
                      Gap(8.h),
                      ProfileMenuItem(
                        title: "my_bookings".tr(),
                        iconPath: AppAssets.calendarCheckSolid,
                        onTap: () {
                          // Navigate to my bookings
                        },
                      ),
                      Gap(8.h),

                      ProfileMenuItem(
                        title: "previous_bookings".tr(),
                        iconPath: AppAssets.calendarSolid,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                Gap(16.h),

                AppCard(
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        title: "support".tr(),
                        iconPath: AppAssets.headset,
                        onTap: () {},
                      ),
                      Gap(8.h),

                      ProfileMenuItem(
                        title: "settings".tr(),
                        iconPath: AppAssets.gear,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.userSettings);
                        },
                      ),
                    ],
                  ),
                ),

                Gap(16.h),

                // Settings & Logout
                AppCard(
                  child: ProfileMenuItem(
                    title: "logout".tr(),
                    iconPath: AppAssets.logout,
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () {
                      DialogService.confirm(
                        context,
                        title: "logout_confirmation".tr(),
                        subtitle: "logout_message".tr(),
                        onConfirm: () {
                          context.read<TopMainCubit>().logout();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Column(
        children: [
          Gap(32.h),

          // Welcome Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.container,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.container.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Welcome Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.blue02.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.blue02.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 40.w,
                    color: theme.colorScheme.blue02,
                  ),
                ),
                Gap(24.h),

                // Welcome Text
                Text(
                  "welcome_message_logged_out".tr(),
                  style: AppTextStyles.tajawal22W700.copyWith(
                    color: theme.colorScheme.text100,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(12.h),
                Text(
                  "login_required_message".tr(),
                  style: AppTextStyles.tajawal16W400.copyWith(
                    color: theme.colorScheme.text60,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(32.h),

                // Login Button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.blue02,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.blue02.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 20.w,
                            ),
                            Gap(8.w),
                            Text(
                              "login_button_text".tr(),
                              style: AppTextStyles.tajawal16W500.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(32.h),

          // Additional Info Cards
          _buildInfoCard(
            context,
            theme,
            icon: Icons.medical_services_rounded,
            title: "professional_medical_care".tr(),
            subtitle: "access_expert_doctors".tr(),
            color: theme.colorScheme.blue02,
          ),

          Gap(16.h),

          _buildInfoCard(
            context,
            theme,
            icon: Icons.support_agent_rounded,
            title: "support_24_7".tr(),
            subtitle: "support_here_anytime".tr(),
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: AppTextStyles.tajawal16W500.copyWith(
          color: theme.colorScheme.text100,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 24.w, color: color),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: theme.colorScheme.text100,
                  ),
                ),
                Gap(4.h),
                Text(
                  subtitle,
                  style: AppTextStyles.tajawal14W400.copyWith(
                    color: theme.colorScheme.text60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
