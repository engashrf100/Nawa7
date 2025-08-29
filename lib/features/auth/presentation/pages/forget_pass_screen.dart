import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
  import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/auth/presentation/widgets/field_with_country_picker.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _phoneController = TextEditingController();

  void _onForgetPassword() {
      final selectedCountry = context.read<SettingsCubit>().state.selectedCountry;

    context.read<ForgetPassCubit>().forgotPassword(
      ForgetPasswordRequestModel(
        countryId: selectedCountry?.id.toString() ?? '',
        phone: _phoneController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: GradientIconButton(
                          assetPath: AppAssets.backArrow,
                          useSvg: true,
                          isLeft: false,
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(8.w),
                          onTap: () => Navigator.pop(context),
                        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BackgroundWidget00(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          child: BlocConsumer<ForgetPassCubit, ForgetPassState>(
            listener: (context, state) {
              AuthStateHandler.handle(
                context: context,
                state: state,
                phoneNumber: _phoneController.text.trim(),
              );
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
                  _buildLabel(context, 'phone_label'.tr()),
                  PhoneFieldWithCountryPicker(
                    controller: _phoneController,
                    hintText: 'phone_label'.tr(),
                    errorMessages: state.phoneError,
                  ),
                  Gap(50.h),
                  AppPrimaryButton(
                    width: 329.w,
                    height: 49.h,
                    title: "continue".tr(),
                    onTap: _onForgetPassword,
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
    "forget_password".tr(),
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
