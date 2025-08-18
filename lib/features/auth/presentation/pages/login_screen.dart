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
import 'package:nawah/features/auth/data/model/requests/login_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/auth/presentation/widgets/field_with_country_picker.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/widgets/theme_lang_switcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final selectedCountry = context.read<SettingsCubit>().state.selectedCountry;

    context.read<LoginCubit>().login(
      LoginRequestModel(
        countryId: selectedCountry?.id.toString() ?? '',
        phone: _phoneController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) =>
          AuthStateHandler.handle(context: context, state: state),
      listenWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => Scaffold(
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const BackButton00(),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
        //  floatingActionButton: buildThemeLangFab(context: context),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BackgroundWidget00(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(60.h),
                _buildWelcomeText(theme),
                Gap(30.h),

                _buildLabel(context, 'phone_label'.tr()),
                PhoneFieldWithCountryPicker(
                  controller: _phoneController,
                  hintText: 'phone_label'.tr(),
                  errorMessages: state.phoneError,
                ),
                Gap(16.h),

                _buildLabel(context, 'password_label'.tr()),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "password".tr(),
                  obscureText: true,
                  errorMessages: state.passwordError,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgetPass),
                    child: Text(
                      "forget_password".tr(),
                      style: AppTextStyles.tajawal12W700.copyWith(
                        color: AppColors.lightBlue03,
                      ),
                    ),
                  ),
                ),
                Gap(30.h),

                AppPrimaryButton(
                  width: 329.w,
                  height: 49.h,
                  title: "login".tr(),
                  onTap: _onLoginPressed,
                ),
                Gap(10.h),

                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'no_account'.tr(),
                            style: AppTextStyles.tajawal14W400.copyWith(
                              color: theme.colorScheme.text100,
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 5.w)),
                          TextSpan(
                            text: 'create_account'.tr(),
                            style: AppTextStyles.tajawal14W700.copyWith(
                              color: AppColors.lightBlue03,
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
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) => Text(
    "welcome_back".tr(),
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
