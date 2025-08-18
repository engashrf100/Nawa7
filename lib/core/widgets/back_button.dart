import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';

class BackButton00 extends StatelessWidget {
  final VoidCallback? onTap;

  const BackButton00({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.homeBg,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(6.w),
            Icon(
              Icons.arrow_back_ios,
              size: 16.sp,
              color: Theme.of(context).colorScheme.text100,
            ),
          ],
        ),
      ),
    );
  }
}
