import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/core/widgets/dot_indicator.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:nawah/features/home/data/model/home_model.dart';

class HomeSliderSection extends StatefulWidget {
  const HomeSliderSection({super.key, required this.sliders});
  final List<Sliders> sliders;

  @override
  State<HomeSliderSection> createState() => _HomeSliderSectionState();
}

class _HomeSliderSectionState extends State<HomeSliderSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220.h,
          child: CarouselSlider.builder(
            itemCount: widget.sliders.length,
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: AppCard(
                  color: Theme.of(context).colorScheme.homeBg.withOpacity(0.55),
                  height: double.infinity,
                  width: double.infinity,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A17223B),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomCachedImage(
                      imageUrl: widget.sliders[index].image ?? "",
                      width: 264.w,
                      height: 164.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 184.h,
              enlargeCenterPage: false,
              viewportFraction: 0.76.w,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ),
        SliderDotIndicator(
          itemCount: widget.sliders.length,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }
}
