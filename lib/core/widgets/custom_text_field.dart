import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final List<String>? errorMessages;
  final VoidCallback? onSubmitted;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool autoUnfocus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.errorMessages,
    this.onSubmitted,
    this.onTap,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.autoUnfocus = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode?.dispose();
  }

  void _toggleObscure() {
    setState(() => _isObscured = !_isObscured);
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call();
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          onTapOutside: (event) {
            if (widget.autoUnfocus) {
              FocusScope.of(context).unfocus();
            }
          },

          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          obscureText: _isObscured,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: _handleSubmitted,
          onTap: _handleTap,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.greyStroke,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.tajawal14W400.copyWith(
              color: colorScheme.text60,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: widget.errorMessages != null
                    ? Colors.red
                    : colorScheme.greyStroke,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: widget.errorMessages != null
                    ? Colors.red
                    : colorScheme.greyStroke,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: widget.errorMessages != null
                    ? Colors.red
                    : AppColors.lightBlue02,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIconConstraints: widget.suffixIcon != null
                ? BoxConstraints(minWidth: 90.w)
                : null,
            suffixIcon: widget.obscureText
                ? GestureDetector(
                    onTap: _toggleObscure,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SvgPicture.asset(
                        _isObscured
                            ? AppAssets.obscureText
                            : AppAssets.obscureText,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  )
                : widget.suffixIcon,
          ),
          style: AppTextStyles.tajawal14W400.copyWith(
            color: colorScheme.text100,
          ),
        ),

        // ✅ Show Validation Errors
        if (widget.errorMessages != null &&
            widget.errorMessages!.isNotEmpty) ...[
          SizedBox(height: 4.h),
          ...widget.errorMessages!.map(
            (error) => Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                "• $error",
                style: AppTextStyles.tajawal12W400.copyWith(
                  color: Colors.red,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
