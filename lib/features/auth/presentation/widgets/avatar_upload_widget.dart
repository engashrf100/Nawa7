import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class AvatarUploadWidget extends StatefulWidget {
  final String? currentAvatarUrl;
  final Function(File file) onImageSelected;
  final bool isLoading;
  final double? uploadProgress;
  final String? errorMessage;

  const AvatarUploadWidget({
    super.key,
    this.currentAvatarUrl,
    required this.onImageSelected,
    this.isLoading = false,
    this.uploadProgress,
    this.errorMessage,
  });

  @override
  State<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends State<AvatarUploadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  File? _selectedImage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AvatarUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != oldWidget.errorMessage) {
      _errorMessage = widget.errorMessage;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        final maxSize = 5 * 1024 * 1024; // 5MB

        if (fileSize > maxSize) {
          setState(() {
            _errorMessage = "avatar_too_large".tr();
          });
          return;
        }

        setState(() {
          _selectedImage = file;
          _errorMessage = null;
        });

        widget.onImageSelected(file);
      }
    } catch (e) {
      setState(() {
        _errorMessage = "avatar_upload_failed".tr();
      });
    }
  }

  Widget _buildAvatarImage() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60.r),
        child: Image.file(
          _selectedImage!,
          width: 120.w,
          height: 120.h,
          fit: BoxFit.cover,
        ),
      );
    }

    if (widget.currentAvatarUrl != null &&
        widget.currentAvatarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60.r),
        child: Image.network(
          widget.currentAvatarUrl!,
          width: 120.w,
          height: 120.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.lightGray00,
        borderRadius: BorderRadius.circular(60.r),
        border: Border.all(color: AppColors.primaryWhite, width: 3.w),
      ),
      child: Icon(Icons.person, size: 60.w, color: AppColors.lightGray00),
    );
  }

  Widget _buildUploadProgress() {
    if (widget.uploadProgress == null || widget.uploadProgress == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        color: Colors.black54,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: widget.uploadProgress,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlue02),
              strokeWidth: 3.w,
            ),
            Gap(8.h),
            Text(
              "${(widget.uploadProgress! * 100).toInt()}%",
              style: AppTextStyles.tajawal12W500.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar Display
        GestureDetector(
          onTap: widget.isLoading ? null : _pickImage,
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildAvatarImage(),
                    if (widget.isLoading) _buildUploadProgress(),
                  ],
                ),
              );
            },
          ),
        ),
        Gap(16.h),

        // Upload Button
        if (!widget.isLoading)
          Container(
            width: 140.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.lightBlue02,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(18.r),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 16.w),
                      Gap(6.w),
                      Text(
                        "upload_avatar".tr(),
                        style: AppTextStyles.tajawal12W500.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Error Message
        if (_errorMessage != null) ...[
          Gap(8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.error.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            child: Text(
              _errorMessage!,
              style: AppTextStyles.tajawal12W400.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
