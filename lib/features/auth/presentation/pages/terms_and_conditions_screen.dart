import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nawah/core/const/app_assets.dart';

import 'package:nawah/core/widgets/back_button.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageCode = context.locale.languageCode;
      context.read<SettingsCubit>().refreshTermsData(languageCode);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return WillPopScope(
      onWillPop: () async {
        // Clear data when screen is popped
        context.read<SettingsCubit>().clearTermsData();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BackgroundWidget00(
          child: Column(
            children: [
              // AppBar with back button (same style as signup screen)
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 32.w, right: 32.w),
                child: Row(
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
                    const Spacer(),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    switch (state.termsState) {
                      case TermsLoadingState.loading:
                        return Center(
                          child: MedicalRowLoadingDialog(
                            loadingText: "loading_terms".tr(),
                            isDismissible: false,
                          ),
                        );
                      
                      case TermsLoadingState.loaded:
                        return _buildTermsContent(context, state.termsData);
                      
                      case TermsLoadingState.error:
                        return ErrorScreen(
                          errorMessage: state.termsErrorMessage ?? 'Failed to load terms',
                          onRetry: () async {
                            final languageCode = context.locale.languageCode;
                            await context.read<SettingsCubit>().refreshTermsData(languageCode);
                          },
                        );
                      
                      case TermsLoadingState.noInternet:
                        return ErrorScreen(
                          errorMessage: 'no_internet_connection'.tr(),
                          onRetry: () async {
                            final languageCode = context.locale.languageCode;
                            await context.read<SettingsCubit>().refreshTermsData(languageCode);
                          },
                        );
                      
                      default:
                        return const Center(child: Text('Loading...'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsContent(BuildContext context, SettingsModel? data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (data?.data == null || data!.data!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 48,
              color: colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'no_terms_content_available'.tr(),
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final languageCode = context.locale.languageCode;
        await context.read<SettingsCubit>().refreshTermsData(languageCode);
      },
      color: AppColors.lightBlue03,
      backgroundColor: colorScheme.surface,
      strokeWidth: 1,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: data.data!.map((setting) {
            if (setting.value == null || setting.value!.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: HtmlWidget(
                setting.value!,
                textStyle: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontFamily: 'Tajawal',
                  color: colorScheme.onSurface,
                ),
                // Enhanced CSS support for better rendering
                customStylesBuilder: (element) {
                  if (element.localName == 'div') {
                    return {'text-align': 'start'};
                  }
                  if (element.localName == 'img') {
                    return {'max-width': '100%', 'height': 'auto'};
                  }
                  if (element.localName == 'p') {
                    return {'margin': '0 0 16px 0'};
                  }
                  if (element.localName == 'h1' || element.localName == 'h2' || element.localName == 'h3') {
                    return {'margin': '24px 0 16px 0', 'font-weight': '600'};
                  }
                  return null;
                },
                // Better HTML rendering options
                renderMode: RenderMode.column,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
