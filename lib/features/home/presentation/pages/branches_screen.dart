import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_center_item.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_screen_skeleton.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key}) : super(key: key);

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  static const double _loadMoreThreshold = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - _loadMoreThreshold) {
      context.read<HomeCubit>().loadMoreBranches();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {},
                buildWhen: (previousState, currentState) {
                  if (previousState.allBranches != currentState.allBranches) {
                    return true;
                  }
                  if (previousState.isLoadingMore !=
                      currentState.isLoadingMore) {
                    return true;
                  }
                  if (previousState.hasMoreData != currentState.hasMoreData) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state.isLoading && state.allBranches.isEmpty) {
                    return const HomeScreenSkeleton();
                  }

                  if (state.hasError && state.allBranches.isEmpty) {
                    return ErrorScreen(
                      errorMessage: state.errorMessage,
                      onRetry: () async {
                        await context.read<HomeCubit>().getInitData();
                      },
                    );
                  }

                  if (state.allBranches.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return _buildBranchesList(state, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.container.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: 60.w,
                color: theme.colorScheme.text60,
              ),
            ),
            Gap(24.h),
            Text(
              "branches_empty".tr(),
              style: AppTextStyles.tajawal20W500.copyWith(
                color: theme.colorScheme.text100,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              "branches_empty_subtitle".tr(),
              style: AppTextStyles.tajawal14W400.copyWith(
                color: theme.colorScheme.text60,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(32.h),
            _buildRefreshButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildRefreshButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.blue02,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.blue02.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await context.read<HomeCubit>().getInitData();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 20.w),
                Gap(8.w),
                Text(
                  "retry_button".tr(),
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchesList(HomeState state, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<HomeCubit>().getInitData(),
      color: theme.colorScheme.blue02,
      backgroundColor: theme.colorScheme.container,
      strokeWidth: 1,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        physics: const BouncingScrollPhysics(),
        itemCount: state.allBranches.length + 1,
        itemBuilder: (context, index) {
          if (index < state.allBranches.length) {
            return _buildBranchItem(state.allBranches[index], theme, index);
          } else {
            return _buildPaginationFooter(state, theme);
          }
        },
      ),
    );
  }

  Widget _buildBranchItem(dynamic center, ThemeData theme, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: MedicalCenterItem(center: center),
    );
  }

  Widget _buildPaginationFooter(HomeState state, ThemeData theme) {
    if (state.isLoadingMore) {
      return _buildLoadingIndicator(theme);
    } else if (!state.hasMoreData && state.allBranches.isNotEmpty) {
      return _buildEndOfListIndicator(theme);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.blue02,
              ),
              backgroundColor: theme.colorScheme.container,
            ),
          ),
          Gap(16.h),
          Text(
            "loading_more".tr(),
            style: AppTextStyles.tajawal14W400.copyWith(
              color: theme.colorScheme.text60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndOfListIndicator(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.container.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 30.w,
              color: theme.colorScheme.text60,
            ),
          ),
          Gap(16.h),
          Text(
            "no_more_branches".tr(),
            style: AppTextStyles.tajawal16W500.copyWith(
              color: theme.colorScheme.text80,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
