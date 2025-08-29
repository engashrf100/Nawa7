import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocListener, MultiBlocListener, ReadContext, BlocBuilder;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/core/widgets/bottom_navigation_bar.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';
import 'package:nawah/features/home/presentation/pages/branches_screen.dart';
import 'package:nawah/features/home/presentation/pages/home_screen.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_header_section.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/main_state_handler.dart';
import 'package:nawah/features/auth/presentation/pages/user_profile_screen.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> _buildScreens() {
    return [
      HomeScreen(
        onTabNavigation: (int index) {
          setState(() => _currentIndex = index);
        },
      ), // index 0
      AboutUsScreen(), // index 1
      DoctorsScreen(), // index 2 (middle)
      BranchesScreen(), // index 3
      UserProfileScreen(), // index 4 - Now using UserProfileScreen
    ];
  }

  CurrentScreen _getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return CurrentScreen.home;
      case 1:
        return CurrentScreen.aboutUs;
      case 2:
        return CurrentScreen.doctors;
      case 3:
        return CurrentScreen.branches;
      case 4:
        return CurrentScreen.account;
      default:
        return CurrentScreen.home;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getInitData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) =>
              MainStateHandler.handle(context: context, state: state),
          listenWhen: (previous, current) => previous.status != current.status,
        ),
        BlocListener<TopMainCubit, TopMainState>(
          listener: (context, state) =>
              AuthStateHandler.handle(context: context, state: state),
          listenWhen: (previous, current) => previous.status != current.status,
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.colorScheme.homeBg,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          backgroundColor: theme.colorScheme.homeBg,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          title: HomeHeaderSection(
            currentScreen: _getCurrentScreen(_currentIndex),
            onTabNavigation: (int index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(index: _currentIndex, children: _buildScreens()),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            if (index == _currentIndex) return;

            // Clear about us data when leaving the tab
            if (_currentIndex == 1) {
              context.read<SettingsCubit>().clearAboutUsData();
            }

            setState(() {
              _currentIndex = index;
            });

            // Load about us data when entering the tab
            if (index == 1) {
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
          },
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
 /* @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageCode = context.locale.languageCode;
      // Always fetch fresh data when entering the screen
      context.read<SettingsCubit>().refreshAboutUsData(languageCode);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
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
                final languageCode = context.locale.languageCode;
                await context.read<SettingsCubit>().refreshAboutUsData(languageCode);
              },
            );
          
          case AboutUsLoadingState.noInternet:
            return ErrorScreen(
              errorMessage: 'no_internet_connection'.tr(),
              onRetry: () async {
                final languageCode = context.locale.languageCode;
                await context.read<SettingsCubit>().refreshAboutUsData(languageCode);
              },
            );
          
          case AboutUsLoadingState.initial:
          default:
            return Center(
              child: Text('loading'.tr()),
            );
        }
      },
        ),
      
    );
  }

  Widget _buildAboutUsContent(BuildContext context, SettingsModel? data) {
    if (data?.data == null || data!.data!.isEmpty) {
      return Center(
        child: Text('no_about_us_content_available'.tr()),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final languageCode = context.locale.languageCode;
        await context.read<SettingsCubit>().refreshAboutUsData(languageCode);
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

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('doctors_screen_title'.tr()));
}
