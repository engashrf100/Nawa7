import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class CustomMedicalRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double displacement;
  final Color? backgroundColor;

  const CustomMedicalRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.displacement = 40.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomMedicalRefreshIndicator> createState() =>
      _CustomMedicalRefreshIndicatorState();
}

class _CustomMedicalRefreshIndicatorState
    extends State<CustomMedicalRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool _isRefreshing = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Rotation animation for stethoscope
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation for entrance
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Pulse animation for heartbeat effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startRefreshAnimation() {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
        _isVisible = true;
      });

      _scaleController.forward();
      _rotationController.repeat();
      _pulseController.repeat(reverse: true);
      _fadeController.forward();
    }
  }

  void _stopRefreshAnimation() {
    if (_isRefreshing) {
      _rotationController.stop();
      _pulseController.stop();

      _scaleController.reverse().then((_) {
        _fadeController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isRefreshing = false;
              _isVisible = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      elevation: 0,
      onRefresh: () async {
        _startRefreshAnimation();
        try {
          await widget.onRefresh();
        } finally {
          await Future.delayed(const Duration(milliseconds: 500));
          _stopRefreshAnimation();
        }
      },
      //  displacement: widget.displacement,
      backgroundColor: Colors.transparent,
      color: Colors.transparent,
      strokeWidth: 0,
      child: Stack(
        children: [widget.child, if (_isVisible) _buildCustomIndicator()],
      ),
    );
  }

  Widget _buildCustomIndicator() {
    final theme = Theme.of(context);

    return Positioned(
      top: widget.displacement,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimation,
          _rotationAnimation,
          _pulseAnimation,
          _fadeAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.lightBlue03.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Stethoscope Icon
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.lightBlue03.withOpacity(0.2),
                                AppColors.lightBlue03.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.lightBlue03.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.stethoscopeIcon,
                            width: 24.w,
                            height: 24.h,
                            color: AppColors.lightBlue03,
                          ),
                        ),
                      ),
                    ),

                    Gap(12.w),

                    // Animated Text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        "refreshing".tr(),
                        style: AppTextStyles.tajawal14W500.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    Gap(8.w),

                    // Pulse Indicator
                    _buildPulseIndicator(theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPulseIndicator(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Container(
              width: 20.w * _pulseAnimation.value,
              height: 20.h * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue03.withOpacity(
                    (1 - (_pulseAnimation.value - 1) / 0.2).clamp(0.0, 0.3),
                  ),
                  width: 2,
                ),
              ),
            ),
            // Inner dot
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightBlue03,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightBlue03.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Alternative Minimal Version for simpler use cases
class SimpleMedicalRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const SimpleMedicalRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<SimpleMedicalRefreshIndicator> createState() =>
      _SimpleMedicalRefreshIndicatorState();
}

class _SimpleMedicalRefreshIndicatorState
    extends State<SimpleMedicalRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        _controller.repeat();
        try {
          await widget.onRefresh();
        } finally {
          _controller.stop();
          _controller.reset();
        }
      },
      backgroundColor: theme.colorScheme.surface,
      color: AppColors.lightBlue03,
      displacement: 60.0,
      strokeWidth: 3.0,
      child: widget.child,
    );
  }
}

// Usage Extension for easy implementation
extension RefreshIndicatorExtension on Widget {
  Widget withMedicalRefresh({
    required Future<void> Function() onRefresh,
    bool useSimple = false,
  }) {
    if (useSimple) {
      return SimpleMedicalRefreshIndicator(onRefresh: onRefresh, child: this);
    }

    return CustomMedicalRefreshIndicator(onRefresh: onRefresh, child: this);
  }
}
