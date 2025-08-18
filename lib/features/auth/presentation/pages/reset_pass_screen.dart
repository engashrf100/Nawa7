import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({ 
    super.key,
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;
  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final selectedCountry = context.read<SettingsCubit>().state.selectedCountry;

    final model = ResetPasswordRequestModel(
      phone: widget.phoneNumber,
      countryId: selectedCountry?.id.toString() ?? '',
      otp: widget.otp,
      password: newPasswordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
    );

    context.read<ForgetPassCubit>().resetPassword(model);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const BackButton00(),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BackgroundWidget00(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          child: BlocConsumer<ForgetPassCubit, ForgetPassState>(
            listener: (context, state) {
              AuthStateHandler.handle(context: context, state: state);
            },
            listenWhen: (previous, current) =>
                previous.status != current.status,

            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(100.h),
                  _buildWelcomeText(theme),
                  Gap(150.h),
                  _buildLabel(context, 'password_label'.tr()),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: "password_label".tr(),
                    obscureText: true,
                    errorMessages: state.passwordError,
                  ),
                  Gap(5.h),
                  _buildLabel(context, 'confirm_password_label'.tr()),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "confirm_password_label".tr(),
                    obscureText: true,
                    errorMessages: state.confirmPasswordError,
                  ),
                  Gap(50.h),
                  AppPrimaryButton(
                    width: 329.w,
                    height: 49.h,
                    title: "continue".tr(),
                    onTap: _onSavePressed,
                  ),
                  Gap(10.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(ThemeData theme) => Text(
    "change_password".tr(),
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
