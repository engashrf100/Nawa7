import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/pages/branch_details_screen.dart';
import 'package:nawah/features/home/presentation/widgets/branch_details_widgets/social_buttons_row.dart';

class CenterImageSlider extends StatefulWidget {
  final List<String> images;
  final Branch? branch;

  const CenterImageSlider({super.key, required this.images, this.branch});

  @override
  State<CenterImageSlider> createState() => _CenterImageSliderState();
}

class _CenterImageSliderState extends State<CenterImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _startAutoSlide();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Main image slider
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 321.w,
            height: 284.h,
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
        ),

        // Gradient overlay
        Container(
          width: 341.w,
          height: 124.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFFD1D6E5),
                const Color(0xFFD1D6E5).withOpacity(0.0),
              ],
            ),
          ),
        ),

        // Social buttons
        Positioned(
          bottom: 20.h,
          child: SocialButtonsRow(branch: widget.branch),
        ),
      ],
    );
  }
}
