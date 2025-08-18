import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class SelectableRowItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSvg;

  const SelectableRowItem({
    Key? key,
    required this.imageUrl,
    this.isSvg = false,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: _buildFlagIcon(),
                    ),
                  ),
                  TextSpan(
                    text: label,
                    style: AppTextStyles.tajawal14W500.copyWith(
                      color: colorScheme.text80,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colorScheme.blue02 : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.lightGray00, width: 1.5.w),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagIcon() {
    final double size = 20.w;

    if (isSvg) {
      return SvgPicture.asset(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
  }
}
