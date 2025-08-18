import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/app_section_header.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/clients_rating_slider.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_banner_section.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_card_with_button.dart';
import 'package:nawah/features/settings/presentation/widgets/theme_lang_switcher.dart';

import '../widgets/branch_details_widgets/advanced_clickable_contact_cards.dart';
import '../widgets/branch_details_widgets/center_image_slider.dart';
import '../widgets/branch_details_widgets/center_info.dart';
import '../widgets/branch_details_widgets/expandable_header_card.dart';

class BranchDetailsScreen extends StatelessWidget {
  final AppBranch appBranch;
  final List<ClientReview> clientReviews;

  const BranchDetailsScreen({
    super.key,
    required this.appBranch,
    required this.clientReviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final branch = appBranch.data;

    return Scaffold(
      appBar: _buildAppBar(theme, context, branch),
      backgroundColor: theme.colorScheme.homeBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(10.h),
                  _buildMainCard(branch, theme),
                  Gap(20),
                  _buildBranchServices(appBranch),
                  Gap(20),
                  _buildClientReviews(clientReviews),
                  Gap(20),
                  const HomeBannerSection(),
                  Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(Branch? branch, ThemeData theme) {
    return Center(
      child: AppCard(
        width: 341.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CenterImageSlider(images: branch?.gallery ?? [], branch: branch),
            Gap(20.h),
            CenterInfo(
              theme: theme,
              name: branch?.name ?? "",
              logo: branch?.image ?? "",
              location: branch?.region?.name ?? "",
              branchId: branch?.id?.toString(),
            ),
            Gap(10.h),
            _buildAddressCard(branch, theme),
            Gap(10.h),
            _buildAppointmentsCard(branch, theme),
            Gap(10.h),
            AdvancedClickableContactCards(appBranch: appBranch),
            Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Branch? branch, ThemeData theme) {
    return ExpandableHeaderCard(
      title: 'address'.tr(),
      description: Text(
        branch?.addressDescription ?? "",
        style: AppTextStyles.tajawal16W400.copyWith(
          color: theme.colorScheme.text60,
        ),
      ),
      isInitiallyExpanded: true,
      img: AppAssets.location,
    );
  }

  Widget _buildAppointmentsCard(Branch? branch, ThemeData theme) {
    if (branch?.workDays == null) return const SizedBox.shrink();

    return ExpandableHeaderCard(
      title: 'appointments'.tr(),
      description: _buildAvailableDaysDescription(branch!.workDays!),
      isInitiallyExpanded: false,
      img: AppAssets.calendar,
    );
  }

  AppBar _buildAppBar(ThemeData theme, BuildContext context, Branch? branch) {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.homeBg,
      elevation: 0,
      title: Container(
        width: 361.w,
        height: 70.h,
        padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GradientIconButton(
              assetPath: AppAssets.backArrow,
              useSvg: true,
              isLeft: false,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: Center(
                child: Text(
                  branch?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: theme.colorScheme.text100,
                  ),
                ),
              ),
            ),
            GradientIconButton(
              assetPath: AppAssets.search,
              useSvg: true,
              isLeft: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchServices(AppBranch branch) {
    return AppCard(
      width: 361.w,
      child: Column(
        children: [
          AppSectionHeader(title: "branch_services".tr(), onTap: () {}),
          SizedBox(height: 16.h),
          HomeCardWithButton(onTap: () {}),
          SizedBox(height: 16.h),
          HomeCardWithButton(onTap: () {}),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildClientReviews(List<ClientReview> clientReviews) {
    if (clientReviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCard(
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

  Widget _buildAvailableDaysDescription(WorkDays workDays) {
    final availableDays = <String>[];

    if (workDays.sunday == true) availableDays.add('sunday'.tr());
    if (workDays.monday == true) availableDays.add('monday'.tr());
    if (workDays.tuesday == true) availableDays.add('tuesday'.tr());
    if (workDays.wednesday == true) availableDays.add('wednesday'.tr());
    if (workDays.thursday == true) availableDays.add('thursday'.tr());
    if (workDays.friday == true) availableDays.add('friday'.tr());
    if (workDays.saturday == true) availableDays.add('saturday'.tr());

    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: availableDays
            .map(
              (day) => Chip(
                label: SizedBox(
                  width: 80.w,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.border00,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(child: Text(day)),
                    ],
                  ),
                ),
                backgroundColor: AppColors.darkBlue02,
                labelStyle: AppTextStyles.tajawal14W700.copyWith(
                  color: AppColors.border00,
                ),
                side: BorderSide(color: AppColors.darkBlue02, width: 1.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 4,
                shadowColor: AppColors.darkBlue02.withOpacity(0.3),
              ),
            )
            .toList(),
      ),
    );
  }
}
