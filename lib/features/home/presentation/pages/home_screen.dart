import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_state.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/consultation_form.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/app_section_header.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/clients_rating_slider.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_banner_section.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_button_card.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_card_with_button.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_center_item.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_screen_skeleton.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_slider_section.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/our_clients_slider.dart';
import 'package:nawah/features/settings/presentation/widgets/theme_lang_switcher.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onTabNavigation;

  const HomeScreen({super.key, this.onTabNavigation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previousState, currentState) {
        // Case 1: homeData changes

        if (previousState.homeData != currentState.homeData) {
          return true;
        }

        // Case 2: Start app with no internet, homeData stays null
        if (previousState.homeData == null && currentState.homeData == null) {
          return true;
        }

        return false;
      },

      builder: (context, state) {
        if (state.isLoading) {
          return HomeScreenSkeleton();
        }

        if (state.hasError) {
          return ErrorScreen(
            errorMessage: state.errorMessage,
            onRetry: () async {
              await context.read<HomeCubit>().getInitData();
            },
          );
        }

        if (state.isLoaded && state.homeData != null) {
          return Scaffold(
            backgroundColor: theme.colorScheme.homeBg,
            //     floatingActionButton: buildThemeLangFab(context: context),
            body: RefreshIndicator(
              onRefresh: () async =>
                  await context.read<HomeCubit>().getInitData(),
              color: theme.colorScheme.blue02,
              backgroundColor: theme.colorScheme.container,
              strokeWidth: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HomeSliderSection(sliders: state.homeData!.sliders!),
                    Gap(20.h),
                    HomeBannerSection(),
                    Gap(10.h),
                    _MedicalCentersSection(
                      centers: state.homeData!.HomeBranches!,
                      onTabNavigation: onTabNavigation,
                    ),
                    Gap(10.h),
                    _MedicalservicesSection(),
                    Gap(10.h),
                    _MedicalClintsSection(
                      contracts: state.homeData!.contracts!,
                    ),
                    Gap(10.h),
                    _WhyUsection(benefits: state.homeData!.benefit!),
                    Gap(10.h),
                    _RatingsSection(
                      clientReviews: state.homeData!.clientReviews!,
                    ),
                    Gap(10.h),
                    _MedicalFormSection(),
                    Gap(10.h),
                    HomeBannerSection(),
                    Gap(10.h),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _MedicalCentersSection extends StatelessWidget {
  final List<Branch> centers;
  final Function(int)? onTabNavigation;
  const _MedicalCentersSection({required this.centers, this.onTabNavigation});
  @override
  Widget build(BuildContext context) {
    if (centers.isEmpty) return const SizedBox.shrink();
    return AppCard(
      width: 361.w,

      child: Column(
        children: [
          AppSectionHeader(
            title: "home_medical_centers_title".tr(),
            onTap: () {
              if (onTabNavigation != null) {
                onTabNavigation!(3); // Navigate to branches tab (index 3)
              }
            },
          ),
          Gap(12.h),

          ...List.generate(
            centers.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != centers.length - 1 ? 8.h : 0,
              ),
              child: MedicalCenterItem(center: centers[index]),
            ),
          ),
          SizedBox(height: 16.h),

          AllServicesButton(
            title: 'all_branches'.tr(),
            onTap: () {
              if (onTabNavigation != null) {
                onTabNavigation!(3); // Navigate to branches tab (index 3)
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MedicalservicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,

      child: Column(
        children: [
          AppSectionHeader(title: "medical_services".tr(), onTap: () {}),

          SizedBox(height: 16.h),
          HomeCardWithButton(onTap: () {}),
          SizedBox(height: 16.h),
          HomeCardWithButton(onTap: () {}),
          SizedBox(height: 16.h),

          AllServicesButton(title: "all_services".tr(), onTap: () {}),
        ],
      ),
    );
  }
}

class _MedicalClintsSection extends StatelessWidget {
  final List<Contracts> contracts;

  const _MedicalClintsSection({required this.contracts});

  @override
  Widget build(BuildContext context) {
    if (contracts.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AppCard(
          child: AppSectionHeader(
            title: "more_than_contracts".tr(
              args: [contracts.length.toString()],
            ),

            onTap: () {},
            showViewAll: false,
          ),
        ),
        SizedBox(height: 16.h),
        OurClientsSlider(images: contracts.map((e) => e.image ?? "").toList()),
      ],
    );
  }
}

class _WhyUsection extends StatelessWidget {
  final List<Benefit> benefits;

  const _WhyUsection({required this.benefits});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,

      child: Column(
        children: [
          AppSectionHeader(
            title: "why_choose_nawah".tr(),
            onTap: () {},
            showViewAll: false,
          ),

          ...List.generate(
            benefits.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != benefits.length - 1 ? 8.h : 0,
              ),
              child: HomeCard(benefit: benefits[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingsSection extends StatelessWidget {
  final List<ClientReview> clientReviews;

  const _RatingsSection({required this.clientReviews});

  @override
  Widget build(BuildContext context) {
    if (clientReviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCard(
          width: 361.w,
          child: AppSectionHeader(
            title: "what_our_clients_say".tr(),
            onTap: () {},
            showViewAll: false,
          ),
        ),
        SizedBox(height: 16.h),
        ClientsRatingSlider(ratings: clientReviews),
      ],
    );
  }
}

class _MedicalFormSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,

      child: Column(
        children: [
          AppSectionHeader(
            title: "need_consultation".tr(),
            onTap: () {},
            showViewAll: false,
          ),
          SizedBox(height: 16.h),
          ConsultationForm(),
        ],
      ),
    );
  }
}
