import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';

class OurClientsSlider extends StatelessWidget {
  final List<String> images;
  const OurClientsSlider({super.key, required this.images});

  bool get hasTwoRows => images.length >= 6;

  List<String> get topImages =>
      hasTwoRows ? images.sublist(0, (images.length / 2).floor()) : images;

  List<String> get bottomImages =>
      hasTwoRows ? images.sublist((images.length / 2).floor()) : [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hasTwoRows ? 240.h : 120.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AutoScrollingList(images: topImages, reverse: false),
          if (hasTwoRows) ...[
            SizedBox(height: 10.h),
            _AutoScrollingList(images: bottomImages, reverse: true),
          ],
        ],
      ),
    );
  }
}

class _AutoScrollingList extends StatefulWidget {
  final List<String> images;
  final bool reverse;
  const _AutoScrollingList({required this.images, this.reverse = false});

  @override
  State<_AutoScrollingList> createState() => _AutoScrollingListState();
}

class _AutoScrollingListState extends State<_AutoScrollingList>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30))
          ..addListener(_autoScroll)
          ..repeat();
  }

  void _autoScroll() {
    if (!_scrollController.hasClients) return;

    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.offset;
    double delta = 0.5; // سرعة الحركة

    if (!widget.reverse) {
      // التحريك الطبيعي للأمام
      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo((currentScroll + delta).clamp(0, maxScroll));
      }
    } else {
      // التحريك العكسي فعليًا
      if (currentScroll <= 0) {
        _scrollController.jumpTo(maxScroll);
      } else {
        _scrollController.jumpTo((currentScroll - delta).clamp(0, maxScroll));
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeatedImages = List.generate(
      20,
      (index) => widget.images[index % widget.images.length],
    );

    return SizedBox(
      height: 115.h,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: repeatedImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: _ClientItem(image: repeatedImages[index]),
          );
        },
      ),
    );
  }
}

class _ClientItem extends StatelessWidget {
  final String image;
  const _ClientItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 113.67.w,
      height: 115.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          width: 93.67.w,
          height: 95.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CustomCachedImage(
                imageUrl: image,
                width: 55.w,
                height: 55.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
