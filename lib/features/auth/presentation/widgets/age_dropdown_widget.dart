import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_state.dart';

class BirthDateDropdownWidget extends StatelessWidget {
  const BirthDateDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.selectedDob != current.selectedDob,
      builder: (context, state) {
        final birthDate = DateTime.tryParse(state.selectedDob);
        final age = birthDate != null ? DateTime.now().year - birthDate.year : 0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'birth_date_label'.tr()),
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Theme.of(context).colorScheme.greyStroke,
              ),
              child: InkWell(
                onTap: () => _showIOSBirthDatePicker(context, state.selectedDob),
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Text(
                        birthDate != null 
                            ? '${birthDate.day}/${birthDate.month}/${birthDate.year} ($age ${'years'.tr()})'
                            : 'birth_date_label'.tr(),
                        style: AppTextStyles.tajawal14W500.copyWith(
                          color: Theme.of(context).colorScheme.text60,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).colorScheme.text40,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.dobError != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 12.w),
                child: Text(
                  state.dobError!.first,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(BuildContext context, String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Text(
      text,
      style: AppTextStyles.tajawal16W500.copyWith(
        color: Theme.of(context).colorScheme.text100,
      ),
    ),
  );

  void _showIOSBirthDatePicker(BuildContext context, String currentDob) {
    final currentDate = DateTime.tryParse(currentDob) ?? DateTime(1991, 1, 1);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // Title
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'select_birth_date'.tr(),
                style: AppTextStyles.tajawal20W500.copyWith(
                  color: Theme.of(context).colorScheme.text100,
                ),
              ),
            ),
            
            // iOS-style picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: currentDate,
                maximumDate: DateTime(DateTime.now().year - 18, 12, 31), // Minimum age 18
                minimumDate: DateTime(DateTime.now().year - 120, 1, 1), // Maximum age 120
                onDateTimeChanged: (DateTime dateTime) {
                  final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
                  context.read<RegisterCubit>().updateDob(formattedDate);
                },
                backgroundColor: Colors.transparent,
                itemExtent: 40.h,
              ),
            ),
            
            // Confirm button
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(bottomSheetContext),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue03,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'confirm'.tr(),
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
