import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';

class HomeScreenSkeleton extends StatefulWidget {
  const HomeScreenSkeleton({super.key});

  @override
  State<HomeScreenSkeleton> createState() => _HomeScreenSkeletonState();
}

class _HomeScreenSkeletonState extends State<HomeScreenSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Slider Section Skeleton
            _SliderSectionSkeleton(animation: _animation),
            Gap(20.h),

            // Banner Section Skeleton
            _BannerSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Medical Centers Section Skeleton
            _MedicalCentersSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Medical Services Section Skeleton
            _MedicalServicesSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Medical Clients Section Skeleton
            _MedicalClientsSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Why Us Section Skeleton
            _WhyUsSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Ratings Section Skeleton
            _RatingsSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Medical Form Section Skeleton
            _MedicalFormSectionSkeleton(animation: _animation),
            Gap(10.h),

            // Second Banner Section Skeleton
            _BannerSectionSkeleton(animation: _animation),
            Gap(10.h),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Animation<double> animation;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.animation,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                theme.colorScheme.border,
                theme.colorScheme.border.withOpacity(0.5),
                theme.colorScheme.border,
              ],
              transform: GradientRotation(animation.value * 3.14),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------

class _SliderSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _SliderSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: AppCard(
                    width: 200.w,
                    height: 184.h,
                    child: _SkeletonBox(
                      width: 200.w,
                      height: 184.h,
                      animation: animation,
                      borderRadius: 8,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: AppCard(
                    width: 264.w,
                    height: 184.h,
                    child: _SkeletonBox(
                      width: 264.w,
                      height: 184.h,
                      animation: animation,
                      borderRadius: 8,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: AppCard(
                    width: 200.w,
                    height: 184.h,
                    child: _SkeletonBox(
                      width: 200.w,
                      height: 184.h,
                      animation: animation,
                      borderRadius: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(10.h),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.border,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

class _BannerSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _BannerSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,
      height: 134.h,
      child: _SkeletonBox(
        width: 361.w,
        height: 134.h,
        animation: animation,
        borderRadius: 12,
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _MedicalCentersSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _MedicalCentersSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(width: 150.w, height: 20.h, animation: animation),
                _SkeletonBox(width: 60.w, height: 20.h, animation: animation),
              ],
            ),
          ),
          Gap(12.h),

          // Medical center items
          ...List.generate(
            2,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != 1 ? 8.h : 0,
                left: 16.w,
                right: 16.w,
              ),
              child: _MedicalCenterItemSkeleton(animation: animation),
            ),
          ),

          Gap(16.h),

          // All services button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _SkeletonBox(
              width: 341.w,
              height: 80.h,
              animation: animation,
              borderRadius: 14,
            ),
          ),

          Gap(16.h),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _MedicalCenterItemSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _MedicalCenterItemSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 341.w,
      child: Column(
        children: [
          // Image slider
          _SkeletonBox(
            width: 321.w,
            height: 143.h,
            animation: animation,
            borderRadius: 8,
          ),
          Gap(10.h),

          // Center info
          SizedBox(
            width: 321.w,
            height: 93.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                _SkeletonBox(
                  width: 74.w,
                  height: 93.h,
                  animation: animation,
                  borderRadius: 8,
                ),
                Gap(10.w),

                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SkeletonBox(
                        width: double.infinity,
                        height: 20.h,
                        animation: animation,
                      ),
                      Gap(8.h),
                      _SkeletonBox(
                        width: 120.w,
                        height: 16.h,
                        animation: animation,
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          _SkeletonBox(
                            width: 16.w,
                            height: 16.h,
                            animation: animation,
                          ),
                          Gap(6.w),
                          _SkeletonBox(
                            width: 100.w,
                            height: 16.h,
                            animation: animation,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(10.h),

          // Details button
          _SkeletonBox(
            width: 321.w,
            height: 68.h,
            animation: animation,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _MedicalServicesSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _MedicalServicesSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(width: 140.w, height: 20.h, animation: animation),
                _SkeletonBox(width: 60.w, height: 20.h, animation: animation),
              ],
            ),
          ),

          Gap(16.h),

          // Service cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _SkeletonBox(
              width: 329.w,
              height: 60.h,
              animation: animation,
            ),
          ),
          Gap(16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _SkeletonBox(
              width: 329.w,
              height: 60.h,
              animation: animation,
            ),
          ),
          Gap(16.h),

          // All services button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _SkeletonBox(
              width: 341.w,
              height: 80.h,
              animation: animation,
              borderRadius: 14,
            ),
          ),

          Gap(16.h),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _MedicalClientsSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _MedicalClientsSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          width: 361.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: _SkeletonBox(
              width: 200.w,
              height: 20.h,
              animation: animation,
            ),
          ),
        ),
        Gap(16.h),

        // Clients slider
        SizedBox(
          height: 80.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: _SkeletonBox(
                    width: 60.w,
                    height: 60.h,
                    animation: animation,
                    borderRadius: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

class _WhyUsSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _WhyUsSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: _SkeletonBox(
              width: 120.w,
              height: 20.h,
              animation: animation,
            ),
          ),

          // Benefits
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != 2 ? 8.h : 16.h,
                left: 16.w,
                right: 16.w,
              ),
              child: _SkeletonBox(
                width: 329.w,
                height: 60.h,
                animation: animation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _RatingsSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _RatingsSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          width: 361.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: _SkeletonBox(
              width: 160.w,
              height: 20.h,
              animation: animation,
            ),
          ),
        ),
        Gap(16.h),

        // Rating cards
        SizedBox(
          height: 120.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: _SkeletonBox(
                    width: 160.w,
                    height: 120.h,
                    animation: animation,
                    borderRadius: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

class _MedicalFormSectionSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const _MedicalFormSectionSkeleton({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 361.w,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: _SkeletonBox(
              width: 180.w,
              height: 20.h,
              animation: animation,
            ),
          ),
          Gap(16.h),

          // Form elements
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _SkeletonBox(width: 329.w, height: 48.h, animation: animation),
                Gap(12.h),
                _SkeletonBox(width: 329.w, height: 48.h, animation: animation),
                Gap(12.h),
                _SkeletonBox(width: 329.w, height: 100.h, animation: animation),
                Gap(16.h),
                _SkeletonBox(
                  width: 329.w,
                  height: 48.h,
                  animation: animation,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
          Gap(16.h),
        ],
      ),
    );
  }
}
