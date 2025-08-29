import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class MedicalCenterItem extends StatelessWidget {
  final Branch center;
  final VoidCallback onTap;

  const MedicalCenterItem({
    super.key,
    required this.center,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.container,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.border,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            _buildBranchImage(),
            Gap(16.w),
            Expanded(
              child: _buildBranchInfo(theme),
            ),
            _buildArrowIcon(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.darkBlue02.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: center.image != null && center.image!.isNotEmpty
            ? CustomCachedImage(
                imageUrl: center.image!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.medical_services_outlined,
                color: AppColors.darkBlue02,
                size: 24.sp,
              ),
      ),
    );
  }

  Widget _buildBranchInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          center.name ?? '',
          style: AppTextStyles.tajawal16W500.copyWith(
            color: theme.colorScheme.text100,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(4.h),
        if (center.region?.name != null)
          Text(
            center.region!.name!,
            style: AppTextStyles.tajawal14W400.copyWith(
              color: theme.colorScheme.text60,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Gap(4.h),
        if (center.addressDescription != null)
          Text(
            center.addressDescription!,
            style: AppTextStyles.tajawal12W400.copyWith(
              color: theme.colorScheme.text60,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        Gap(8.h),
        if (center.categories != null && center.categories!.isNotEmpty)
          _buildCategoriesChips(theme),
      ],
    );
  }

  Widget _buildCategoriesChips(ThemeData theme) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: center.categories!.take(3).map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.darkBlue02.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            category.name ?? '',
            style: AppTextStyles.tajawal12W400.copyWith(
              color: AppColors.darkBlue02,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildArrowIcon(ThemeData theme) {
    return Icon(
      Icons.arrow_forward_ios,
      color: theme.colorScheme.text60,
      size: 16.sp,
    );
  }
}
