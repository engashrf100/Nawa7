import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/core/widgets/rtl_flippable_widget.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';

class MedicalCenterItem extends StatelessWidget {
  final Branch center;

  const MedicalCenterItem({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: 341.w,
      child: Column(
        children: [
          if (center.gallery != null && center.gallery!.isNotEmpty)
            _CenterImageSlider(
              images: center.gallery!,
              branchId: center.id!.toString(),
            ),

          Gap(10.h),
          _CenterInfo(
            theme: theme,
            name: center.name ?? "",
            location: center.region?.name ?? "",
            logo: center.image ?? "",
            branchId: center.id!.toString(),
          ),
          Gap(10.h),
          _DetailsButton(
            theme: theme,
            onTap: () async {
              await context.read<HomeCubit>().getBranchById(center.id!);
            },
          ),
        ],
      ),
    );
  }
}

class _CenterImageSlider extends StatefulWidget {
  final List<String> images;
  final String branchId;
  const _CenterImageSlider({
    Key? key,
    required this.images,
    required this.branchId,
  }) : super(key: key);

  @override
  State<_CenterImageSlider> createState() => _CenterImageSliderState();
}

class _CenterImageSliderState extends State<_CenterImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || widget.images.length <= 1) return;
      final nextPage = (_currentIndex + 1) % widget.images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _currentIndex = nextPage;
      _startAutoSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 321.w,
        height: 143.h,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return CustomCachedImage(
              imageUrl: widget.images[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class _CenterInfo extends StatelessWidget {
  final ThemeData theme;
  final String name;
  final String location;
  final String logo;
  final String branchId;

  const _CenterInfo({
    required this.logo,
    required this.theme,
    required this.name,
    required this.location,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 321.w,
      height: 93.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Logo Container
          Container(
            width: 74.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.border,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CustomCachedImage(imageUrl: logo, fit: BoxFit.cover),
            ),
          ),
          Gap(10.w),

          /// Text Details Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.border,
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Name
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.tajawal16W500.copyWith(
                        color: theme.colorScheme.text80,
                      ),
                    ),
                  ),
                  Gap(6.h),

                  /// Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SvgPicture.asset(
                        AppAssets.location,
                        width: 16.w,
                        height: 16.h,
                        color: AppColors.lightBlue03,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.tajawal14W400.copyWith(
                            color: theme.colorScheme.text60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onTap;

  const _DetailsButton({required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 321.w,
        height: 68.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.container,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Arrow Icon
            Container(
              width: 40.w,
              height: 40.h,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.homeBg,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: theme.colorScheme.border, width: 1),
              ),
              child: Transform.scale(
                scaleX: -1,
                child: Image.asset(
                  AppAssets.arrowUp,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.lightBlue03,
                  matchTextDirection: true,
                ),
              ),
            ),
            Gap(16.w),

            /// Title
            Text(
              "home_center_details".tr(),
              style: AppTextStyles.tajawal16W500.copyWith(
                color: theme.colorScheme.text80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
