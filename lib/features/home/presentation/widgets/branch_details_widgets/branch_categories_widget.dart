import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/app_section_header.dart';

class BranchCategoriesWidget extends StatelessWidget {
  final List<Category>? categories;

  const BranchCategoriesWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories == null || categories!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildHeader(),
        Gap(20.h),
        _buildVerticalCategoriesList(context),
      ],
    );
  }

  Widget _buildHeader() {
    return AppSectionHeader(
      title: 'branch_categories'.tr(),
      onTap: () {},
      showViewAll: false,
    );
  }

  Widget _buildVerticalCategoriesList(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < categories!.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == categories!.length - 1 ? 0 : 16.h),
            child: _buildVerticalCategoryCard(categories![i], context),
          ),
      ],
    );
  }

  Widget _buildVerticalCategoryCard(Category category, BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.darkBlue02.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue02.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category Logo/Icon
          _buildCategoryLogo(category),
          Gap(16.w),
          
          // Category Name
          Expanded(
            child: Center(
              child: _buildCategoryName(category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLogo(Category category) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.darkBlue02.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.darkBlue02.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: _buildLogoContent(category),
      ),
    );
  }

  Widget _buildLogoContent(Category category) {
    if (category.logo != null && category.logo!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: category.logo!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholderIcon(),
        errorWidget: (context, url, error) => _buildPlaceholderIcon(),
      );
    }
    
    return _buildPlaceholderIcon();
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: Colors.transparent,
      child: Icon(
        Icons.medical_services_outlined,
        color: AppColors.darkBlue02,
        size: 24.sp,
      ),
    );
  }

  Widget _buildCategoryName(Category category) {
    return Text(
      category.name ?? '',
      style: AppTextStyles.tajawal16W500.copyWith(
        color: AppColors.darkBlue02,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }


}
