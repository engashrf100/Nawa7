import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

// ================================
// DIALOG TYPES & CONFIGURATIONS
// ================================

enum DialogType { success, error, warning, info, confirm, custom }

class DialogConfig {
  final String? title;
  final String? subtitle;
  final Widget? customSubtitle;
  final Widget? icon;
  final String? iconPath;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final bool showCloseIcon;
  final bool isDismissible;
  final List<DialogAction> actions;
  final Duration? autoDismissAfter;

  const DialogConfig({
    this.title,
    this.subtitle,
    this.customSubtitle,
    this.icon,
    this.iconPath,
    this.iconBackgroundColor,
    this.iconColor,
    this.showCloseIcon = true,
    this.isDismissible = true,
    this.actions = const [],
    this.autoDismissAfter,
  });

  factory DialogConfig.success({
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? actionText,
    VoidCallback? onAction,
    Duration? autoDismissAfter,
    bool isDismissible = true,
  }) {
    return DialogConfig(
      title: title ?? 'dialog_success'.tr(),
      subtitle: subtitle,
      customSubtitle: customSubtitle,
      iconPath: AppAssets.success,
      iconBackgroundColor: Colors.green.shade100,
      iconColor: Colors.green,
      isDismissible: isDismissible,
      actions: onAction != null
          ? [
              DialogAction.primary(
                text: actionText ?? 'dialog_ok'.tr(),
                onPressed: onAction,
              ),
            ]
          : [],
      autoDismissAfter: autoDismissAfter,
    );
  }

  factory DialogConfig.error({
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? actionText,
    VoidCallback? onAction,
    String? closeText,
    VoidCallback? onClose,
    bool isDismissible = true,
  }) {
    final actions = <DialogAction>[];

    if (onAction != null) {
      actions.add(
        DialogAction.primary(
          text: actionText ?? 'dialog_try_again'.tr(),
          onPressed: onAction,
        ),
      );
    }

    return DialogConfig(
      title: title ?? 'dialog_error'.tr(),
      subtitle: subtitle,
      customSubtitle: customSubtitle,
      iconPath: AppAssets.error,
      iconBackgroundColor: Colors.red.shade100,
      iconColor: Colors.red,
      isDismissible: isDismissible,
      actions: actions,
    );
  }

  factory DialogConfig.confirm({
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    String? iconPath,
    bool isDismissible = true,
  }) {
    return DialogConfig(
      title: title ?? 'dialog_confirm'.tr(),
      subtitle: subtitle,
      customSubtitle: customSubtitle,
      iconPath: iconPath ?? AppAssets.logout,
      iconBackgroundColor: AppColors.border00,
      iconColor: AppColors.darkBlue02,
      isDismissible: isDismissible,
      actions: [
        DialogAction.primary(
          text: confirmText ?? 'dialog_confirm'.tr(),
          onPressed: onConfirm,
        ),
        DialogAction.secondary(
          text: cancelText ?? 'dialog_cancel'.tr(),
          onPressed: onCancel,
        ),
      ],
    );
  }
}

class DialogAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isDestructive;

  const DialogAction({
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.backgroundColor,
    this.textColor,
    this.isDestructive = false,
  });

  factory DialogAction.primary({
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return DialogAction(
      text: text,
      onPressed: onPressed,
      isPrimary: true,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory DialogAction.secondary({
    required String text,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return DialogAction(
      text: text,
      onPressed: onPressed,
      isPrimary: false,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory DialogAction.destructive({
    required String text,
    VoidCallback? onPressed,
  }) {
    return DialogAction(
      text: text,
      onPressed: onPressed,
      isPrimary: true,
      isDestructive: true,
    );
  }
}

// ================================
// MEDICAL ROW LOADING DIALOG (SEPARATE)
// ================================

class MedicalRowLoadingDialog extends StatefulWidget {
  final String? loadingText;
  final bool isDismissible;

  const MedicalRowLoadingDialog({
    Key? key,
    this.loadingText,
    this.isDismissible = false,
  }) : super(key: key);

  @override
  State<MedicalRowLoadingDialog> createState() =>
      _MedicalRowLoadingDialogState();
}

class _MedicalRowLoadingDialogState extends State<MedicalRowLoadingDialog>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

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

    // Start all animations
    _scaleController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: widget.isDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.border,
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
                        widget.loadingText ?? "loading".tr(),
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
            );
          },
        ),
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

// ================================
// MAIN DIALOG WIDGET (NO ANIMATIONS)
// ================================

class FlexibleDialog extends StatefulWidget {
  final DialogType type;
  final DialogConfig config;

  const FlexibleDialog({super.key, required this.type, required this.config});

  @override
  State<FlexibleDialog> createState() => _FlexibleDialogState();
}

class _FlexibleDialogState extends State<FlexibleDialog> {
  @override
  void initState() {
    super.initState();

    // Auto dismiss if configured
    if (widget.config.autoDismissAfter != null) {
      Future.delayed(widget.config.autoDismissAfter!, () {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: widget.config.isDismissible,
      child: Dialog(
        backgroundColor: colorScheme.border,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.w, minWidth: 280.w),
          decoration: BoxDecoration(
            color: colorScheme.border.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              width: 2,
              color: AppColors.lightWhite.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.config.showCloseIcon) _buildCloseButton(),
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: widget.config.showCloseIcon ? 0 : 32.h,
                  bottom: 32.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(),
                    if (_hasContent()) SizedBox(height: 20.h),
                    _buildContent(),
                    if (widget.config.actions.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _buildActions(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasContent() {
    return widget.config.title != null ||
        widget.config.subtitle != null ||
        widget.config.customSubtitle != null;
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.greyStroke,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: Theme.of(context).colorScheme.text40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.config.icon != null) {
      return widget.config.icon!;
    }

    if (widget.config.iconPath != null) {
      return Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: widget.config.iconBackgroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.config.iconPath!,
            width: 40.w,
            height: 40.h,
            colorFilter: widget.config.iconColor != null
                ? ColorFilter.mode(widget.config.iconColor!, BlendMode.srcIn)
                : null,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.config.title != null) _buildTitle(),
        if (widget.config.title != null &&
            (widget.config.subtitle != null ||
                widget.config.customSubtitle != null))
          SizedBox(height: 12.h),
        if (widget.config.customSubtitle != null)
          widget.config.customSubtitle!
        else if (widget.config.subtitle != null)
          _buildSubtitle(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.config.title!.tr(),
      textAlign: TextAlign.center,
      style: AppTextStyles.tajawal16W500.copyWith(
        color: Theme.of(context).colorScheme.text100,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      widget.config.subtitle!.tr(),
      textAlign: TextAlign.center,
      style: AppTextStyles.tajawal14W500.copyWith(
        color: Theme.of(context).colorScheme.text60,
      ),
    );
  }

  Widget _buildActions() {
    if (widget.config.actions.isEmpty) return const SizedBox.shrink();

    if (widget.config.actions.length == 1) {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(widget.config.actions.first),
      );
    }

    return Row(
      children: widget.config.actions.asMap().entries.map((entry) {
        final action = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: _buildActionButton(action),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(DialogAction action) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;

    if (action.backgroundColor != null && action.textColor != null) {
      backgroundColor = action.backgroundColor!;
      textColor = action.textColor!;
    } else if (action.isDestructive) {
      backgroundColor = Colors.red;
      textColor = Colors.white;
    } else if (action.isPrimary) {
      backgroundColor = AppColors.lightBlue03;
      textColor = AppColors.lightBorder;
    } else {
      backgroundColor = AppColors.border01;
      textColor = colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: () {
        if (action.onPressed != null) {
          action.onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            action.text.tr(),
            style: AppTextStyles.tajawal16W500.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

// ================================
// DIALOG SERVICE
// ================================

class DialogService {
  static Future<T?> show<T>({
    required BuildContext context,
    required DialogType type,
    required DialogConfig config,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: config.isDismissible,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => FlexibleDialog(type: type, config: config),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  // Medical Row Loading Dialog (separate dialog with animations)
  static Future<T?> medicalLoading<T>(
    BuildContext context, {
    String? loadingText,
    bool isDismissible = false,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => MedicalRowLoadingDialog(
        loadingText: loadingText,
        isDismissible: isDismissible,
      ),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  static Future<T?> success<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? actionText,
    VoidCallback? onAction,
    Duration? autoDismissAfter,
    bool isDismissible = true,
  }) {
    return show<T>(
      context: context,
      type: DialogType.success,
      config: DialogConfig.success(
        title: title,
        subtitle: subtitle,
        customSubtitle: customSubtitle,
        actionText: actionText,
        onAction: onAction,
        autoDismissAfter: autoDismissAfter,
        isDismissible: isDismissible,
      ),
    );
  }

  static Future<T?> error<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? actionText,
    VoidCallback? onAction,
    String? closeText,
    VoidCallback? onClose,
    bool isDismissible = true,
  }) {
    return show<T>(
      context: context,
      type: DialogType.error,
      config: DialogConfig.error(
        title: title,
        subtitle: subtitle,
        customSubtitle: customSubtitle,
        actionText: actionText,
        onAction: onAction,
        closeText: closeText,
        onClose: onClose,
        isDismissible: isDismissible,
      ),
    );
  }

  static Future<T?> confirm<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool isDismissible = true,
  }) {
    return show<T>(
      context: context,
      type: DialogType.confirm,
      config: DialogConfig.confirm(
        title: title,
        subtitle: subtitle,
        customSubtitle: customSubtitle,
        confirmText: confirmText,
        onConfirm: onConfirm,
        cancelText: cancelText,
        onCancel: onCancel,
        isDismissible: isDismissible,
      ),
    );
  }

  static Future<T?> custom<T>(
    BuildContext context, {
    String? title,
    String? subtitle,
    Widget? customSubtitle,
    Widget? icon,
    String? iconPath,
    Color? iconBackgroundColor,
    Color? iconColor,
    bool showCloseIcon = false,
    bool isDismissible = true,
    List<DialogAction> actions = const [],
    Duration? autoDismissAfter,
  }) {
    return show<T>(
      context: context,
      type: DialogType.custom,
      config: DialogConfig(
        title: title,
        subtitle: subtitle,
        customSubtitle: customSubtitle,
        icon: icon,
        iconPath: iconPath,
        iconBackgroundColor: iconBackgroundColor,
        iconColor: iconColor,
        showCloseIcon: showCloseIcon,
        isDismissible: isDismissible,
        actions: actions,
        autoDismissAfter: autoDismissAfter,
      ),
    );
  }
}

// ================================
// USAGE EXAMPLES
// ================================

/*
// Medical Loading Dialog (separate with animations)
DialogService.medicalLoading(context);

// Medical Loading with custom text
DialogService.medicalLoading(
  context,
  loadingText: "processing_data".tr(),
);

// Success Dialog (no animations)
DialogService.success(
  context,
  title: "dialog_success_title".tr(),
  subtitle: "dialog_account_created".tr(),
);

// Success Dialog that cannot be dismissed
DialogService.success(
  context,
  title: "dialog_success_title".tr(),
  subtitle: "dialog_account_created".tr(),
  isDismissible: false,
);

// Error Dialog (no animations)
DialogService.error(
  context,
  title: "dialog_error_title".tr(),
  subtitle: "dialog_something_wrong".tr(),
  actionText: "dialog_retry".tr(),
  onAction: () {},
);

// Error Dialog that cannot be dismissed
DialogService.error(
  context,
  title: "dialog_error_title".tr(),
  subtitle: "dialog_something_wrong".tr(),
  actionText: "dialog_retry".tr(),
  onAction: () {},
  isDismissible: false,
);

// Confirm Dialog (no animations)
DialogService.confirm(
  context,
  title: "dialog_confirm_title".tr(),
  subtitle: "dialog_are_you_sure".tr(),
  onConfirm: () {},
);

// Confirm Dialog that cannot be dismissed
DialogService.confirm(
  context,
  title: "dialog_confirm_title".tr(),
  subtitle: "dialog_are_you_sure".tr(),
  onConfirm: () {},
  isDismissible: false,
);
*/
