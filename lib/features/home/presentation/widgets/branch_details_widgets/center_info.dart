import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';

class CenterInfo extends StatelessWidget {
  final ThemeData theme;
  final String name;
  final String logo;
  final String location;
  final String? branchId;

  const CenterInfo({
    required this.logo,
    required this.theme,
    required this.name,
    required this.location,
    this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 321.w,
      height: 80.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Logo Container
          Container(
            height: 80.h,
            width: 64.w,
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
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
