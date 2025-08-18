import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:nawah/features/auth/data/model/requests/resend_code_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/verify_otp_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/otp_cubit/otp_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';

// Your defined colors and text styles

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isActiveAcoount;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.isActiveAcoount,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otpCode = "";

  @override
  Widget build(BuildContext context) {
      final country = context.read<SettingsCubit>().state.selectedCountry;
    final theme = Theme.of(context);

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        AuthStateHandler.handle(
          context: context,
          state: state,
          phoneNumber: widget.phoneNumber,
          otp: _otpCode,
        );
      },
      listenWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final hasErrors =
            state.codeError != null && state.codeError!.isNotEmpty;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const BackButton00(),
            automaticallyImplyLeading: false,
          ),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: BackgroundWidget00(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(200.h),
                    Text(
                      'otp_enter_code'.tr(),
                      style: AppTextStyles.tajawal16W500.copyWith(
                        color: theme.colorScheme.text80,
                      ),
                    ),
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.phoneNumber,
                          style: AppTextStyles.tajawal16W500.copyWith(
                            color: theme.colorScheme.text80,
                            height: 1.h,
                          ),
                        ),
                        if (country?.flag != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CachedNetworkImage(
                              imageUrl: country!.flag!,
                              height: 20.w,
                              width: 20.w,
                            ),
                          ),
                      ],
                    ),
                    Gap(50.h),

                    // OTP Input without controller
                    BlocBuilder<OtpCubit, OtpState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            PinCodeTextField(
                              appContext: context,
                              length: 4,
                              animationType: AnimationType.fade,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _otpCode = value;
                              },
                              onCompleted: (value) {
                                _otpCode = value;
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(4.r),
                                fieldHeight: 66.h,
                                fieldWidth: 70.25.w,
                                borderWidth: 1.w,
                                activeFillColor: AppColors.lightBorder,
                                selectedFillColor: AppColors.lightBorder,
                                inactiveFillColor: AppColors.lightBorder,
                                activeColor: AppColors.lightBlue02,
                                selectedColor: AppColors.lightBlue02,
                                inactiveColor: AppColors.dark20,
                              ),
                              enableActiveFill: true,
                            ),
                            if (hasErrors) _buildErrorWidget(),
                          ],
                        );
                      },
                    ),

                    Gap(20.h),
                    OtpTimerWidget(onTimerFinished: () {}),
                    Gap(20.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          context.read<OtpCubit>().resendCode(
                            ResendCodeRequestModel(
                              phone: widget.phoneNumber,
                              countryId: country!.id.toString(),
                            ),
                          );
                        },
                        child: Text(
                          'otp_resend_code'.tr(),
                          style: AppTextStyles.tajawal14W500.copyWith(
                            color: AppColors.lightBlue02,
                          ),
                        ),
                      ),
                    ),
                    Gap(100.h),
                    AppPrimaryButton(
                      width: 329.w,
                      height: 49.h,
                      title: "otp_continue".tr(),
                      onTap: () =>
                          context.read<OtpCubit>().verifyOtpForRegistration(
                            VerifyOtpRequestModel(
                              countryId: country!.id.toString(),
                              phone: widget.phoneNumber,
                              code: _otpCode,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    final errors = context.watch<OtpCubit>().state.codeError;
    final hasErrors = errors != null && errors.isNotEmpty;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: hasErrors
          ? Column(
              children: [
                Gap(10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.error, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20.w,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          errors.first,
                          style: AppTextStyles.tajawal14W500.copyWith(
                            color: AppColors.error,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class OtpTimerWidget extends StatefulWidget {
  final Function() onTimerFinished;
  const OtpTimerWidget({super.key, required this.onTimerFinished});

  @override
  State<OtpTimerWidget> createState() => _OtpTimerWidgetState();
}

class _OtpTimerWidgetState extends State<OtpTimerWidget> {
  late Timer _timer;
  int _secondsLeft = 300; // 5 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        widget.onTimerFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        text: 'otp_resend_timer'.tr(),
        style: AppTextStyles.tajawal14W400.copyWith(
          color: theme.colorScheme.text80,
        ),
        children: [
          TextSpan(
            text: ' ${_formatTime(_secondsLeft)}',
            style: AppTextStyles.tajawal16W500.copyWith(
              color: theme.colorScheme.text80,
            ),
          ),
        ],
      ),
    );
  }
}
