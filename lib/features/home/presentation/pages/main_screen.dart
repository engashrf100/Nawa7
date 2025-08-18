import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocListener, MultiBlocListener, ReadContext;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
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
        appBar: AppBar(
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          backgroundColor: theme.colorScheme.homeBg,
          elevation: 0,
          title: HomeHeaderSection(
            currentScreen: _getCurrentScreen(_currentIndex),
            onTabNavigation: (int index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: _buildScreens()),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('about_us_screen_title'.tr()));
}

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('doctors_screen_title'.tr()));
}
