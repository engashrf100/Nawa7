import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';

class MainStateHandler {
  static Future<void> handle<T>({
    required BuildContext context,
    required T state,

    VoidCallback? retryAction, // Optional retry callback for network errors
  }) async {
    // Extract status and message from the state
    final status = (state as dynamic).status as HomeStatus?;
    final message = (state as dynamic).errorMessage as String?;

    if (status == null) return;

    // Handle loading state first (show dialog, no dismissal)
    if (status == HomeStatus.loading) {
      _showLoadingDialog(context);
      return;
    }

    // For all other states, dismiss the loading dialog first
    _dismissLoadingDialog(context);

    // Define behavior for each state
    switch (status) {
      case HomeStatus.error:
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

      case HomeStatus.branchLoaded:
        final homeCubit = await context.read<HomeCubit>();
        final appBranch = homeCubit.state.branch;
        final clientReviews = homeCubit.state.homeData?.clientReviews;
        if (appBranch == null) return;

        Navigator.pushNamed(
          context,
          AppRoutes.branchDetails,
          arguments: {"appBranch": appBranch, "clientReviews": clientReviews},
        );

        break;

      default:
        // Unhandled states do nothing after dismissing the dialog
        break;
    }
  }

  static void _showLoadingDialog(BuildContext context) {
    DialogService.medicalLoading(
      context,
      loadingText: "loading".tr(),
      // subtitle: "Processing your medical data...",
    );
  }

  static void _dismissLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
