
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:shimmer/shimmer.dart';

class BranchDetailsSkeleton extends StatelessWidget {
  const BranchDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _skeletonIconButton(),
              Expanded(
                child: Center(
                  child: shimmerBox(width: 100.w, height: 20.h),
                ),
              ),
              _skeletonIconButton(),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            AppCard(
              width: 341.w,
              child: Column(
                children: [
                  shimmerBox(width: 321.w, height: 284.h), // Image
                  SizedBox(height: 20.h),
                  shimmerBox(width: 321.w, height: 64.h), // Center Info
                  SizedBox(height: 10.h),
                  _expandableSkeleton(), // Address
                  SizedBox(height: 10.h),
                  _expandableSkeleton(), // Work days
                  SizedBox(height: 10.h),
                  _expandableSkeleton(), // Contact
                  SizedBox(height: 10.h),
                  _expandableSkeleton(), // WhatsApp
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            AppCard(
              width: 361.w,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    shimmerBox(width: 150.w, height: 20.h), // Section Header
                    SizedBox(height: 16.h),
                    shimmerBox(width: double.infinity, height: 80.h),
                    SizedBox(height: 16.h),
                    shimmerBox(width: double.infinity, height: 80.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AppCard(
              width: 361.w,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    shimmerBox(width: 150.w, height: 20.h), // Reviews title
                    SizedBox(height: 16.h),
                    shimmerBox(width: double.infinity, height: 100.h), // Slider
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _skeletonIconButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }

  Widget _expandableSkeleton() {
    return Container(
      width: 341.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              shimmerBox(width: 20.w, height: 20.h),
              SizedBox(width: 10.w),
              shimmerBox(width: 80.w, height: 16.h),
              const Spacer(),
              shimmerBox(width: 36.w, height: 36.h),
            ],
          ),
          SizedBox(height: 20.h),
          shimmerBox(width: double.infinity, height: 16.h),
          SizedBox(height: 10.h),
          shimmerBox(width: double.infinity, height: 16.h),
        ],
      ),
    );
  }
}
