import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/func/configure_system_uI.dart';
import 'package:nawah/core/helper/bloc_observer.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/routing/route_generator.dart';
import 'package:nawah/core/theme/app_themes.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await init();
  configureSystemUI();
  Bloc.observer = ProfessionalBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const Nawah(),
    ),
  );
}

class Nawah extends StatelessWidget {
  const Nawah({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<SettingsCubit>()
              ..initApp()
              ..loadCountries(),
          ),
          BlocProvider(
            create: (context) => sl<TopMainCubit>()..getSavedUser(),
            lazy: false,
          ),

          BlocProvider(create: (context) => sl<HomeCubit>()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: buildLightTheme(),
              darkTheme: buildDarkTheme(),
              themeMode: state.themeMode == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: RouteGenerator.generateRoute,
              navigatorObservers: [HeroController()],
            );
          },
        ),
      ),
    );
  }
}
