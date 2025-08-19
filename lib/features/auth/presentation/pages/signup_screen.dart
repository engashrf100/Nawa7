import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/auth/presentation/widgets/field_with_country_picker.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/auth/presentation/widgets/settings_dialog.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  _submitRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final registerRequest = RegisterRequestModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _confirmPasswordController.text.trim(),
      countryId:
          context.read<SettingsCubit>().state.selectedCountry?.id.toString() ??
          '',
      gender: context.read<RegisterCubit>().state.selectedGender.toString(),
      dob: "1990-01-01",
      email: "a${Random().nextInt(10000)}@example.com",
    );

    context.read<RegisterCubit>().register(registerRequest);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) => AuthStateHandler.handle(
        context: context,
        state: state,
        phoneNumber: _phoneController.text.trim(),
      ),
      listenWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const BackButton00(),
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        resizeToAvoidBottomInset: false,

        backgroundColor: theme.scaffoldBackgroundColor,
        body: BackgroundWidget00(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(60.h),
                  _buildWelcomeText(theme),
                  Gap(30.h),
                  _buildLabel(context, 'full_name'.tr()),
                  CustomTextField(
                    controller: _nameController,
                    hintText: "full_name".tr(),
                    errorMessages: state.firstNameError,
                  ),
                  Gap(5.h),
                  _buildLabel(context, 'phone_label'.tr()),
                  PhoneFieldWithCountryPicker(
                    controller: _phoneController,
                    hintText: 'phone_label'.tr(),
                    errorMessages: state.phoneError,
                  ),
                  Gap(15.h),
                  SelectGenderWidget(),
                  Gap(5.h),
                  _buildLabel(context, 'password_label'.tr()),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "password_label".tr(),
                    obscureText: true,
                    errorMessages: state.passwordError,
                  ),
                  Gap(5.h),
                  _buildLabel(context, 'confirm_password_label'.tr()),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: "confirm_password_label".tr(),
                    obscureText: true,
                    errorMessages: state.confirmPasswordError,
                  ),
                  Gap(20.h),
                  TermsAndPrivacyCheckbox(
                    isChecked: state.isPolicyChecked,
                    onChanged: (val) =>
                        context.read<RegisterCubit>().updatePolicyCheck(val),
                    onConfirmPressed: () => null,
                  ),
                  Gap(20.h),
                  AppPrimaryButton(
                    width: 329.w,
                    height: 49.h,
                    title: "continue".tr(),
                    onTap: () => _submitRegister(context),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'have_account'.tr(),
                              style: AppTextStyles.tajawal12W400.copyWith(
                                color: theme.colorScheme.text100,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 5.w)),
                            TextSpan(
                              text: 'login'.tr(),
                              style: AppTextStyles.tajawal12W700.copyWith(
                                color: AppColors.lightBlue03,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) => Text(
    "register_title".tr(),
    style: AppTextStyles.tajawal32W600.copyWith(
      color: theme.colorScheme.text100,
      letterSpacing: 0.02,
    ),
  );

  Widget _buildLabel(BuildContext context, String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Text(
      text,
      style: AppTextStyles.tajawal16W500.copyWith(
        color: Theme.of(context).colorScheme.text100,
      ),
    ),
  );
}

class TermsAndPrivacyCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onConfirmPressed;

  const TermsAndPrivacyCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.onConfirmPressed,
  }) : super(key: key);

  void _showTermsDialog(BuildContext context) {
    /*    final settingsCubit = context.read<SettingsCubit>();

    // First try to get settings from local storage
    settingsCubit.getLocalSettings().then((localSettings) {
      if (context.mounted && localSettings != null) {
        // Show dialog immediately with local settings
        _showDialog(context, 'Terms of Service', localSettings);
      } else {
        // If no local settings, load from remote
        settingsCubit.loadSettings().then((_) {
          if (context.mounted) {
            final updatedSettings = settingsCubit.state.settings;
            if (updatedSettings != null) {
              _showDialog(context, 'Terms of Service', updatedSettings);
            }
          }
        });
      }
    });*/
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    /*    final settingsCubit = context.read<SettingsCubit>();

    // First try to get settings from local storage
    settingsCubit.getLocalSettings().then((localSettings) {
      if (context.mounted && localSettings != null) {
        // Show dialog immediately with local settings
        _showDialog(context, 'Privacy Policy', localSettings);
      } else {
        // If no local settings, load from remote
        settingsCubit.loadSettings().then((_) {
          if (context.mounted) {
            final updatedSettings = settingsCubit.state.settings;
            if (updatedSettings != null) {
              _showDialog(context, 'Privacy Policy', updatedSettings);
            }
          }
        });
      }
    }); */
  }

  void _showDialog(BuildContext context, String title, SettingsModel settings) {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(title: title, settings: settings),
    );
  }

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
                            text: "terms".tr(),
                            style: const TextStyle(
                              color: AppColors.lightBlue03,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showTermsDialog(context);
                              },
                          ),
                          TextSpan(text: "and".tr()),
                          TextSpan(
                            text: "privacy_policy".tr(),
                            style: const TextStyle(
                              color: AppColors.lightBlue03,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _showPrivacyPolicyDialog(context);
                              },
                          ),
                        ],
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

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.selectedGender != current.selectedGender,
      builder: (context, state) {
        return Row(
          children: [
            _GenderOption(
              label: 'male'.tr(),
              value: '1',
              isSelected: state.selectedGender == '1',
              onTap: () => context.read<RegisterCubit>().updateGender('1'),
            ),
            Gap(16.w),
            _GenderOption(
              label: 'female'.tr(),
              value: '2',
              isSelected: state.selectedGender == '2',
              onTap: () => context.read<RegisterCubit>().updateGender('2'),
            ),
          ],
        );
      },
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => onTap(),
            side: BorderSide(color: AppColors.lightBlue03, width: 1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            activeColor: AppColors.lightBlue03,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Gap(8.w),
          Text(
            label,
            style: AppTextStyles.tajawal16W500.copyWith(
              color: Theme.of(context).colorScheme.text100,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
