import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_cubit.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_state.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _hasLoadedData = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainTabCubit, MainTabState>(
      listener: (context, state) {
        // Only fetch data when user actually navigates to AboutUs tab (index 1)
        if (state.currentIndex == 1 && !_hasLoadedData) {
          _loadAboutUsData();
          _hasLoadedData = true;
        }
        // Clear data when user leaves AboutUs tab
        else if (state.currentIndex != 1 && _hasLoadedData) {
          context.read<SettingsCubit>().clearAboutUsData();
          _hasLoadedData = false;
        }
      },
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // Dismiss loading dialog when data is loaded or error occurs
          if (state.aboutUsState == AboutUsLoadingState.loaded ||
              state.aboutUsState == AboutUsLoadingState.error ||
              state.aboutUsState == AboutUsLoadingState.noInternet) {
            // Check if there's a dialog to dismiss
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            switch (state.aboutUsState) {
              case AboutUsLoadingState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              
              case AboutUsLoadingState.loaded:
                return _buildAboutUsContent(context, state.aboutUsData);
              
              case AboutUsLoadingState.error:
                return ErrorScreen(
                  errorMessage: state.aboutUsErrorMessage ?? 'unknown_error_occurred'.tr(),
                  onRetry: () async {
                    _loadAboutUsData();
                  },
                );
              
              case AboutUsLoadingState.noInternet:
                return ErrorScreen(
                  errorMessage: 'no_internet_connection'.tr(),
                  onRetry: () async {
                    _loadAboutUsData();
                  },
                );
              
              case AboutUsLoadingState.initial:
                return Center(
                  child: Text('loading'.tr()),
                );
            }
          },
        ),
      ),
    );
  }

  void _loadAboutUsData() {
    final languageCode = context.locale.languageCode;
    
    // Show medical loading dialog
    DialogService.medicalLoading(
      context,
      loadingText: "loading_about_us".tr(),
      isDismissible: false,
    );
    
    // Load data
    context.read<SettingsCubit>().refreshAboutUsData(languageCode);
  }

  Widget _buildAboutUsContent(BuildContext context, SettingsModel? data) {
    if (data?.data == null || data!.data!.isEmpty) {
      return Center(
        child: Text('no_about_us_content_available'.tr()),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadAboutUsData();
      },
      color: Theme.of(context).colorScheme.blue02,
      backgroundColor: Theme.of(context).colorScheme.container,
      strokeWidth: 1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: data.data!.map((setting) {
            if (setting.value == null || setting.value!.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: HtmlWidget(
                setting.value!,
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'Tajawal',
                ),
                customStylesBuilder: (element) {
                  if (element.localName == 'div') {
                    return {'text-align': 'start'};
                  }
                  return null;
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
