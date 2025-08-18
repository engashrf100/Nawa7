import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';

class SliderDotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const SliderDotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = currentIndex == index;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 18.w : 5.w,
          height: 5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: isActive
                ? colorScheme
                      .blue02 // #3760F9
                : const Color(0xFFD1D6E5),
          ),
        );
      }),
    );
  }
}
