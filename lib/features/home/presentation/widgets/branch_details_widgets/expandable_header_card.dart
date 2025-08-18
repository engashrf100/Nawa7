import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class ExpandableHeaderCard extends StatefulWidget {
  final String title;
  final Widget description;
  final bool isInitiallyExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final String img;

  const ExpandableHeaderCard({
    super.key,
    required this.title,
    required this.description,
    this.isInitiallyExpanded = false,
    this.onTap,
    this.onMenuTap,
    required this.img,
  });

  @override
  State<ExpandableHeaderCard> createState() => _ExpandableHeaderCardState();
}

class _ExpandableHeaderCardState extends State<ExpandableHeaderCard>
    with SingleTickerProviderStateMixin {
  late bool isExpanded;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isInitiallyExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });

    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(20.w),
      width: 341.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: title + location icon + menu button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title & Location Icon
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset(widget.img),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.tajawal16W500.copyWith(
                          color: theme.colorScheme.text80,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu button with rotation animation
              GestureDetector(
                onTap: _toggleExpanded,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [Color(0xFFEFF4FF), Color(0xFFFFFFFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: AnimatedBuilder(
                    animation: _heightAnimation,
                    builder: (context, child) {
                      return SvgPicture.asset(
                        isExpanded ? AppAssets.dotsHorizontal : AppAssets.dots,
                        width: 16.w,
                        height: 16.h,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Expandable Description with smooth animation
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _heightAnimation,
                child: isExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: widget.description,
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
