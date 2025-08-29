import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:nawah/core/theme/app_colors.dart';

import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/widgets/auth_state_handler.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';
import 'package:nawah/features/home/presentation/pages/branches_screen.dart';
import 'package:nawah/features/home/presentation/pages/home_screen.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/main_state_handler.dart';
import 'package:nawah/features/auth/presentation/pages/user_profile_screen.dart';
import 'package:nawah/features/main/presentation/widgets/main_header_section.dart';
import 'package:nawah/features/main/presentation/widgets/main_bottom_navigation.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_cubit.dart';
import 'package:nawah/features/main/presentation/cubits/main_tab_state.dart';
import 'package:nawah/features/main/presentation/pages/about_us_screen.dart';
import 'package:nawah/features/main/presentation/pages/doctors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      child: BlocProvider(
        create: (context) => MainTabCubit(),
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
            title: const MainHeaderSection(),
          ),
          body: SafeArea(
            top: false,
            child: BlocBuilder<MainTabCubit, MainTabState>(
              buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
              builder: (context, state) {
                return IndexedStack(
                  index: state.currentIndex,
                  children: [
                    HomeScreen(), // index 0
                    AboutUsScreen(), // index 1
                    DoctorsScreen(), // index 2 (middle)
                    BranchesScreen(), // index 3
                    UserProfileScreen(), // index 4
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: const MainBottomNavigation(),
        ),
      ),
    );
  }
}
