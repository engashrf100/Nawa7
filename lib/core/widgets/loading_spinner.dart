import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';

class LoadingSpinner extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final int barsCount;
  final Duration duration;
  final double spacingFactor;

  const LoadingSpinner({
    Key? key,
    this.activeColor = const Color(0xFF3760F9),
    this.inactiveColor = const Color(0xFFD7D8D9),
    this.size = 44.0,
    this.barsCount = 8,
    this.duration = const Duration(milliseconds: 1500),
    this.spacingFactor = 0.8,
  }) : super(key: key);

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.r, // ✅ متوافق مع ScreenUtil
      height: widget.size.r,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final activeIndex =
              (_controller.value * widget.barsCount).floor() % widget.barsCount;
          return CustomPaint(
            painter: _SpinnerPainter(
              activeIndex: activeIndex,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
              barsCount: widget.barsCount,
              size: widget.size.r, // ✅ متوافق مع ScreenUtil
              spacingFactor: widget.spacingFactor,
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;
  final int barsCount;
  final double size;
  final double spacingFactor;

  _SpinnerPainter({
    required this.activeIndex,
    required this.activeColor,
    required this.inactiveColor,
    required this.barsCount,
    required this.size,
    required this.spacingFactor,
  });

  @override
  void paint(Canvas canvas, Size s) {
    final center = s.center(Offset.zero);

    final barWidth = (size * 0.09).w; // ✅ مع ScreenUtil
    final barHeight = (size * 0.27).h; // ✅ مع ScreenUtil

    final radius = (size / 2) - (barHeight / 2) - (size * spacingFactor);

    final rect = Rect.fromLTWH(
      -barWidth / 2,
      -radius - barHeight / 2,
      barWidth,
      barHeight,
    );
    final radiusBorder = Radius.circular(barWidth / 2);

    for (int i = 0; i < barsCount; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * (2 * pi / barsCount));

      final paint = Paint()
        ..color = (i == activeIndex) ? activeColor : inactiveColor;

      canvas.drawRRect(RRect.fromRectAndRadius(rect, radiusBorder), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.activeIndex != activeIndex ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor;
}

// New LoadingOverlay widget
class LoadingOverlay {
  OverlayEntry? _overlayEntry;
  final BuildContext _context;

  LoadingOverlay._(this._context);

  static LoadingOverlay of(BuildContext context) {
    return LoadingOverlay._(context);
  }

  void show() {
    if (_overlayEntry != null) {
      return; // Overlay is already shown
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button dismissal
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
            ),
            child: Material(
              color: Colors.black.withOpacity(
                0.5,
              ), // Semi-transparent background
              child: Center(
                child: LoadingSpinner(
                  activeColor: Theme.of(context).colorScheme.blue02,
                  inactiveColor: AppColors.lightGray00,
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(_context).insert(_overlayEntry!);
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
