import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/widgets/background_widget00.dart';
import 'package:nawah/core/widgets/loading_spinner.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_state.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:nawah/features/settings/presentation/widgets/onboarding/onboarding_header_widget.dart';
import 'package:nawah/features/settings/presentation/widgets/onboarding/onboarding_navigation_widget.dart';
import 'package:nawah/features/settings/presentation/widgets/onboarding/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().loadOnboardingData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    context.read<SettingsCubit>().savePreferences(
      AppPreferencesModel(flowStatus: AppFlowStatus.home),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  void _navigateToLogin() {
    context.read<SettingsCubit>().savePreferences(
      AppPreferencesModel(flowStatus: AppFlowStatus.home),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );

    Navigator.pushNamed(context, AppRoutes.login);
  }

  void _handlePageChanged(int index) {
    context.read<OnboardingCubit>().goToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (onboardingData, currentPageIndex) {
              if (_pageController.hasClients &&
                  _pageController.page?.round() != currentPageIndex) {
                _pageController.animateToPage(
                  currentPageIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return BackgroundWidget00(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Column(
                children: [
                  // Header with back and skip buttons
                  OnboardingHeaderWidget(
                    state: state,
                    onBack: () =>
                        context.read<OnboardingCubit>().goToPreviousPage(),
                    onSkip: _completeOnboarding,
                  ),

                  // PageView
                  Expanded(child: _buildPageView(state)),

                  // Navigation controls
                  OnboardingNavigationWidget(
                    state: state,
                    onNext: () =>
                        context.read<OnboardingCubit>().goToNextPage(),
                    onPrevious: () =>
                        context.read<OnboardingCubit>().goToPreviousPage(),
                    onSkip: _completeOnboarding,
                    onLogin: _navigateToLogin,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageView(OnboardingState state) {
    return state.maybeWhen(
      loaded: (onboardingData, currentPageIndex) {
        final pages = onboardingData.pages;
        if (pages!.isEmpty) {
          return const Center(child: Text('No onboarding content available'));
        }
        return PageView(
          controller: _pageController,
          onPageChanged: _handlePageChanged,
          children: pages.map((page) {
            return OnboardingPageWidget(
              page: page,
              colorScheme: Theme.of(context).colorScheme,
              isWelcome: pages.indexOf(page) == 0,
            );
          }).toList(),
        );
      },
      loading: () => Center(child: LoadingSpinner(size: 30)),
      error: (message) => ErrorScreen(
        errorMessage: message,
        isNoInternet: message == "No internet connection",
        onRetry: () async {
          await context.read<OnboardingCubit>().loadOnboardingData();
        },
      ),
      orElse: () => SizedBox(),
    );
  }
}
