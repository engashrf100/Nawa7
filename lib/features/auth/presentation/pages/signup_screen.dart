

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
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/auth/presentation/widgets/field_with_country_picker.dart';
import 'package:nawah/features/auth/presentation/widgets/age_dropdown_widget.dart';
import 'package:nawah/features/auth/presentation/widgets/terms_and_privacy_checkbox.dart';
import 'package:nawah/features/auth/presentation/widgets/select_gender_widget.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';

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
      dob: context.read<RegisterCubit>().state.selectedDob,
    );

    context.read<RegisterCubit>().register(registerRequest);
  }

  void _showTermsAndConditions(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.termsAndConditions);
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
              title: GradientIconButton(
                          assetPath: AppAssets.backArrow,
                          useSvg: true,
                          isLeft: false,
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(12.w),
                          onTap: () => Navigator.pop(context),
                        ),
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
                  Gap(70.h),
                  _buildWelcomeText(theme),
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
                  Gap(5.h),
                  SelectGenderWidget(),
                  Gap(5.h),
                  BirthDateDropdownWidget(),
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
                  Gap(10.h),
                  TermsAndPrivacyCheckbox(
                    isChecked: state.isPolicyChecked,
                    onChanged: (val) =>
                        context.read<RegisterCubit>().updatePolicyCheck(val),
                    onTermsTap: () => _showTermsAndConditions(context),
                  ),
                  Gap(10.h),
                  AppPrimaryButton(
                    width: 329.w,
                    height: 49.h,
                    title: "continue".tr(),
                    onTap: () => _submitRegister(context),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
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






