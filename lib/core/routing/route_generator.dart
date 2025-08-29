import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/pages/forget_pass_screen.dart';
import 'package:nawah/features/auth/presentation/pages/login_screen.dart';
import 'package:nawah/features/auth/presentation/pages/otp_screen.dart';
import 'package:nawah/features/auth/presentation/pages/reset_pass_screen.dart';
import 'package:nawah/features/auth/presentation/pages/signup_screen.dart';
import 'package:nawah/features/auth/presentation/pages/terms_and_conditions_screen.dart';
import 'package:nawah/features/auth/presentation/pages/user_profile_screen.dart';
import 'package:nawah/features/auth/presentation/pages/user_account_screen.dart';
import 'package:nawah/features/auth/presentation/pages/user_settings_screen.dart';
import 'package:nawah/features/home/presentation/pages/branch_details_screen.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/pages/home_screen.dart';
import 'package:nawah/features/home/presentation/pages/search_screen.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/main/presentation/pages/main_screen.dart';
import 'package:nawah/features/settings/presentation/pages/choose_lang_screen.dart';
import 'package:nawah/features/settings/presentation/pages/onboarding_screen.dart';
import 'package:nawah/features/settings/presentation/pages/theme_screen.dart';
import 'package:nawah/features/settings/presentation/pages/splash_screen.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_cubit.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';
import 'package:nawah/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Main Screens
      case AppRoutes.splash:
        return _fade(const SplashScreen());

      case AppRoutes.lang:
        return _fade(const ChooseLanguageScreen());

      case AppRoutes.theme:
        return _fade(const ChooseThemeScreen());

      case AppRoutes.onBoardig:
        return _fade(
          BlocProvider(
            create: (context) => sl<OnboardingCubit>(),
            child: OnboardingScreen(),
          ),
        );

      case AppRoutes.error:
        final map = args as Map<String, dynamic>;
        return _fade(
          ErrorScreen(
            errorMessage: map['errorMessage'],
            onRetry: map['onRetry'],
          ),
        );

      case AppRoutes.login:
        return _slideFromBottom(
          BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: LoginScreen(),
          ),
        );

      // Auth Screens
      case AppRoutes.register:
        return _fade(
          BlocProvider(
            create: (context) => sl<RegisterCubit>(),
            child: RegisterScreen(),
          ),
        );

      case AppRoutes.forgetPass:
        return _fade(
          BlocProvider(
            create: (context) => sl<ForgetPassCubit>(),
            child: ForgetPasswordScreen(),
          ),
        );

      case AppRoutes.newPass:
        final map = args as Map<String, dynamic>;

        return _fade(
          BlocProvider(
            create: (context) => sl<ForgetPassCubit>(),
            child: ResetPassScreen(
              phoneNumber: map['phoneNumber'],
              otp: map['otp'],
            ),
          ),
        );

      case AppRoutes.activeOtp:
        final map = args as Map<String, dynamic>;

        return _fade(
          BlocProvider(
            create: (context) => sl<OtpCubit>(),
            child: OtpScreen(
              phoneNumber: map['phoneNumber'],
              isActiveAcoount: map['isActiveAccount'],
            ),
          ),
        );

      case AppRoutes.userProfile:
        return _fade(const UserProfileScreen());

      case AppRoutes.userAccount:
        return _fade(const UserAccountScreen());

      case AppRoutes.userSettings:
        return _fade(const UserSettingsScreen());

      case AppRoutes.termsAndConditions:
        return _fade(const TermsAndConditionsScreen());

      // Home Screens
      case AppRoutes.home:
        return _fade(MainScreen());

      case AppRoutes.branchDetails:
        final map = args as Map<String, dynamic>;
        return _heroTransition(
          BranchDetailsScreen(
            appBranch: map['appBranch'],
            clientReviews: map['clientReviews'],
          ),
        );

      case AppRoutes.search:
        final map = args as Map<String, dynamic>;
        final branches = map['initialBranches'] as List<dynamic>? ?? [];
        return _fade(
          SearchScreen(
            initialBranches: branches.cast<Branch>(),
          ),
        );

      // Default (Unknown Route)
      default:
        return _errorRoute();
    }
  }

  /// Error page for unknown routes
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('error_page_title'.tr())),
        body: Center(child: Text('error_page_not_found'.tr())),
      ),
    );
  }

  /// Fade transition
  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  // Slide in from right (typical iOS)
  PageRouteBuilder<T> _slideFromRightRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offset, child: child);
      },
    );
  }

  //Zoom in effect
  PageRouteBuilder<T> _scaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return ScaleTransition(scale: scale, child: child);
      },
    );
  }

  /// Slide from bottom transition
  static PageRouteBuilder _slideFromBottom(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 850),
    );
  }

  ///Slide in with fade
  PageRouteBuilder<T> _slideAndFadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(animation);
        final opacity = Tween<double>(begin: 0, end: 1).animate(animation);
        return SlideTransition(
          position: offset,
          child: FadeTransition(opacity: opacity, child: child),
        );
      },
    );
  }

  // (iOS elegant)
  static Route<T> _fadeScaleSlideIOS<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        final scale = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
    );
  }

  /// Hero transition with enhanced animations
  static Route<T> _heroTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        final scale = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut));
        final slide =
            Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}
