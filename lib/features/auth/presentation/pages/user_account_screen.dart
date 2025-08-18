import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/widgets/profile_form_field.dart';
import 'package:nawah/features/auth/presentation/widgets/avatar_upload_widget.dart';
import 'package:nawah/features/auth/data/model/requests/update_profile_request_model.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/widgets/theme_lang_switcher.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = '1';
  String? _selectedCountryId;
  File? _selectedAvatar;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize with default male gender
    _selectedGender = '1';
    _loadUserData();
  }

  void _loadUserData() {
    final state = context.read<TopMainCubit>().state;
    if (state.user != null) {
      _fullNameController.text = state.user?.name ?? '';
      _emailController.text = state.user?.email ?? '';
      _phoneController.text = state.user?.phone ?? '';
      _selectedGender = state.user?.gender ?? '1';
      _dobController.text = state.user?.dob ?? '';
      _selectedCountryId = state.user?.countryId;
    } else {
      // Set default gender to '1' (male) if no user data
      _selectedGender = '1';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: 361.w,
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
                        "user_account_title".tr(),
                        style: AppTextStyles.tajawal16W500.copyWith(
                          color: theme.colorScheme.text100,
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
            Expanded(
              child: BlocConsumer<TopMainCubit, TopMainState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.profileUpdateSuccess) {
                    DialogService.success(
                      context,
                      title: "profile_updated_successfully".tr(),
                      autoDismissAfter: Duration(seconds: 2),
                    );
                  } else if (state.status == AuthStatus.profileUpdateFailure) {
                    DialogService.error(
                      context,
                      title: "error".tr(),
                      subtitle: state.message ?? "update_failed".tr(),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == AuthStatus.loading &&
                      state.user == null) {
                    return _buildLoadingState();
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        // Avatar Section
                        Center(
                          child: AvatarUploadWidget(
                            currentAvatarUrl: state.user?.avatar,
                            onImageSelected: (file) {
                              setState(() {
                                _selectedAvatar = file;
                              });
                            },
                            isLoading: state.status == AuthStatus.loading,
                            uploadProgress: _uploadProgress,
                            errorMessage: state.avatarError?.first,
                          ),
                        ),
                        Gap(24.h),

                        // Main Form Container
                        AppCard(
                          child: Container(
                            width: 361.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.border,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Full Name Field
                                ProfileFormField(
                                  label: "full_name".tr(),
                                  controller: _fullNameController,
                                  iconPath: AppAssets.userIcon,
                                  errorMessages: state.nameError,
                                ),
                                Gap(20.h),

                                // Email Field
                                ProfileFormField(
                                  label: "email".tr(),
                                  controller: _emailController,
                                  iconPath: AppAssets.userIcon,
                                  keyboardType: TextInputType.emailAddress,
                                  errorMessages: state.emailError,

                                  validator: (value) {
                                    if (state.emailError != null) {
                                      return state.emailError!.first;
                                    }
                                    return null;
                                  },
                                ),
                                Gap(20.h),

                                // Phone Number Field
                                ProfileFormField(
                                  label: "phone_number".tr(),
                                  controller: _phoneController,
                                  iconPath: AppAssets.call,
                                  isPhone: true,
                                  errorMessages: state.phoneError,
                                ),

                                Gap(20.h),

                                // Gender Selection
                                _buildGenderSelection(state),
                                Gap(20.h),

                                // Save Button
                                AppPrimaryButton(
                                  width: 301.w,
                                  height: 49.h,
                                  title: state.status == AuthStatus.loading
                                      ? "updating".tr()
                                      : "save_changes".tr(),
                                  onTap: state.status == AuthStatus.loading
                                      ? null
                                      : _showConfirmChangesDialog,
                                ),

                                Gap(20.h),

                                // Delete Account Button
                                SizedBox(
                                  width: 301.w,
                                  height: 49.h,
                                  child: OutlinedButton(
                                    onPressed: _showDeleteAccountDialog,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: AppColors.error),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "delete_account".tr(),
                                      style: AppTextStyles.tajawal14W500
                                          .copyWith(color: AppColors.error),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(20.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlue02),
          ),
          Gap(16.h),
          Text(
            "loading".tr(),
            style: AppTextStyles.tajawal16W500.copyWith(
              color: AppColors.lightGray00,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection(TopMainState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                value: '1',
                label: "male".tr(),
                isSelected: _selectedGender == '1',
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _buildGenderOption(
                value: '2',
                label: "female".tr(),
                isSelected: _selectedGender == '2',
              ),
            ),
          ],
        ),
        if (state.genderError != null) ...[
          Gap(4.h),
          Text(
            state.genderError!.first,
            style: AppTextStyles.tajawal12W400.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildGenderOption({
    required String value,
    required String label,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        height: 53.h,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.homeBg
              : theme.colorScheme.greyStroke,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryWhite : AppColors.lightGray00,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightBlue02 : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected
                      ? AppColors.lightBlue02
                      : AppColors.lightGray00,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightWhite,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    )
                  : null,
            ),
            Gap(10.w),
            Text(
              label,
              style: AppTextStyles.tajawal14W400.copyWith(
                color: theme.colorScheme.text80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showConfirmChangesDialog() {
    DialogService.confirm(
      context,
      title: "confirm_changes".tr(),
      subtitle: "confirm_changes_message".tr(),
      onConfirm: () {
        Navigator.of(context).pop();
        _saveChanges();
      },
    );
  }

  void _saveChanges() {
    _simulateUploadProgress();

    final request = UpdateProfileRequestModel(
      name: _fullNameController.text.trim().isNotEmpty
          ? _fullNameController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      gender: _selectedGender,
      dob: _dobController.text.trim().isNotEmpty
          ? _dobController.text.trim()
          : null,
      countryId: _selectedCountryId,
      avatar: _selectedAvatar,
    );

    context.read<TopMainCubit>().updateProfile(request);
  }

  void _simulateUploadProgress() {
    if (_selectedAvatar != null) {
      _uploadProgress = 0.0;
      setState(() {});

      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _uploadProgress = 0.3;
          });
        }
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _uploadProgress = 0.7;
          });
        }
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _uploadProgress = 1.0;
          });
        }
      });
    }
  }

  void _showDeleteAccountDialog() {
    DialogService.confirm(
      context,
      title: "delete_account_confirmation".tr(),
      subtitle: "delete_account_message".tr(),
      onConfirm: () {
        Navigator.of(context).pop();
        // TODO: Implement delete account logic
      },
    );
  }
}
