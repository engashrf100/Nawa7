import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.hintText,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Set new timer for 300ms debounce
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.container,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: theme.colorScheme.border,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Gap(12.w),
          Icon(
            Icons.search,
            color: theme.colorScheme.text60,
            size: 20.sp,
          ),
          Gap(8.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search by name, address, or specialty...',
                hintStyle: AppTextStyles.tajawal14W400.copyWith(
                  color: theme.colorScheme.text60,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.tajawal14W500.copyWith(
                color: theme.colorScheme.text100,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: theme.colorScheme.text60,
                size: 18.sp,
              ),
              onPressed: () {
                widget.controller.clear();
                widget.onSearchChanged('');
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 32.w,
                minHeight: 32.h,
              ),
            ),
          Gap(8.w),
        ],
      ),
    );
  }
}
