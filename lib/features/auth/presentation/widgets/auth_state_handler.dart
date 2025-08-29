import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';

class AuthStateHandler {
  static Future<void> handle<T>({
    required BuildContext context,
    required T state,
    String? phoneNumber,
    String? otp,
    VoidCallback? retryAction, // Optional retry callback for network errors
  }) async {
    // Extract status and message from the state
    final status = (state as dynamic).status as AuthStatus?;
    final message = (state as dynamic).message as String?;

    if (status == null) return;

    // Handle loading state first (show dialog, no dismissal)
    if (status == AuthStatus.loading) {
      _showLoadingDialog(context);
      return;
    }

    // For all other states, dismiss the loading dialog first
    _dismissLoadingDialog(context);

    // Define behavior for each state
    switch (status) {
      case AuthStatus.failure:
        final isNetworkError = message == 'auth_no_internet_connection'.tr();

        DialogService.error(
          context,
          title: isNetworkError
              ? 'auth_no_internet_connection'.tr()
              : message ?? 'auth_error'.tr(),
          actionText: "auth_retry".tr(),
          onAction: () => Navigator.pop(context),
        );

        break;

      case AuthStatus.otpRegistrationSuccess:
        DialogService.success(
          context,
          title: "auth_account_activated_success".tr(),
          subtitle: "auth_redirecting_to_home".tr(),
          autoDismissAfter: Duration(seconds: 2),
          isDismissible: false,
        );
        await Future.delayed(Duration(milliseconds: 2000)).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
        });

        break;

      case AuthStatus.otpForPasswordSuccess:
        DialogService.medicalLoading(
          context,
      //    loadingText: "auth_redirecting_to_password_change".tr(),
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.newPass,
          arguments: {'otp': otp, 'phoneNumber': phoneNumber},
        );
        break;

      case AuthStatus.resendCodeSuccess:
        DialogService.success(
          context,
          title: "auth_new_code_sent".tr(),
          subtitle: "auth_new_code_sent_to".tr().replaceAll(
            '{}',
            phoneNumber ?? '',
          ),
          autoDismissAfter: Duration(seconds: 4),
        );
        break;

      case AuthStatus.loginSuccess:
        DialogService.success(
          context,
          title: "auth_login_success".tr(),
          subtitle: "auth_redirecting_to_home".tr(),
          autoDismissAfter: Duration(seconds: 2),
          isDismissible: false,
        );
        await Future.delayed(Duration(milliseconds: 2000)).then((_) {
          Navigator.pop(context);
        });

        break;

      case AuthStatus.registerSuccess:
        DialogService.success(
          context,
          title: "auth_account_created_success".tr(),
          subtitle: "auth_redirecting_to_activation".tr(),
          autoDismissAfter: Duration(seconds: 2),
          isDismissible: false,
        );
        await Future.delayed(Duration(milliseconds: 2300));

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.activeOtp,
          arguments: {'phoneNumber': phoneNumber, 'isActiveAccount': true},
        );
        break;

      case AuthStatus.forgotPasswordSuccess:
        DialogService.medicalLoading(
          context,
        //  loadingText: "auth_redirecting_to_activation".tr(),
        );
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.activeOtp,
          arguments: {'phoneNumber': phoneNumber, 'isActiveAccount': false},
        );
        break;

      case AuthStatus.resetPasswordSuccess:
        DialogService.success(
          context,
          title: "auth_password_changed_success".tr(),
          subtitle: "auth_redirecting_to_login".tr(),
          autoDismissAfter: Duration(seconds: 2),
          isDismissible: false,

        );
        await Future.delayed(Duration(milliseconds: 2000));

        Navigator.pop(context);
        break;

      case AuthStatus.loggedOut:
        DialogService.success(
          context,
          title: "logout_success".tr(),
          subtitle: "auth_redirecting_to_home".tr(),
          autoDismissAfter: Duration(seconds: 2),
          isDismissible: false,
        );

        break;

      default:
        // Unhandled states do nothing after dismissing the dialog
        break;
    }
  }

  static void _showLoadingDialog(BuildContext context) {
    DialogService.medicalLoading(context, loadingText: "loading".tr());
  }

  static void _dismissLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
