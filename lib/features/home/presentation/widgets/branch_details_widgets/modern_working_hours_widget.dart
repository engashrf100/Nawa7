import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class ModernWorkingHoursWidget extends StatelessWidget {
  final WorkTimes? workTimes;
  final WorkDays? workDays;
  final ThemeData theme;

  const ModernWorkingHoursWidget({
    super.key,
    required this.workTimes,
    required this.workDays,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (workTimes == null && workDays == null) return const SizedBox.shrink();

    final days = _buildDaysList();
    
    return Column(
      children: days.map((day) => _buildDayCard(context, day)).toList(),
    );
  }

  List<Map<String, dynamic>> _buildDaysList() {
    if (workDays == null) {
      return [
        {'key': 'sunday', 'value': false, 'times': null},
        {'key': 'monday', 'value': false, 'times': null},
        {'key': 'tuesday', 'value': false, 'times': null},
        {'key': 'wednesday', 'value': false, 'times': null},
        {'key': 'thursday', 'value': false, 'times': null},
        {'key': 'friday', 'value': false, 'times': null},
        {'key': 'saturday', 'value': false, 'times': null},
      ];
    }
    
    return [
      {'key': 'sunday', 'value': workDays!.sunday ?? false, 'times': workTimes?.sunday},
      {'key': 'monday', 'value': workDays!.monday ?? false, 'times': workTimes?.monday},
      {'key': 'tuesday', 'value': workDays!.tuesday ?? false, 'times': workTimes?.tuesday},
      {'key': 'wednesday', 'value': workDays!.wednesday ?? false, 'times': workTimes?.wednesday},
      {'key': 'thursday', 'value': workDays!.thursday ?? false, 'times': workTimes?.thursday},
      {'key': 'friday', 'value': workDays!.friday ?? false, 'times': workTimes?.friday},
      {'key': 'saturday', 'value': workDays!.saturday ?? false, 'times': workTimes?.saturday},
    ];
  }

  Widget _buildDayCard(BuildContext context, Map<String, dynamic> day) {
    final dayKey = day['key'] as String;
    final isWorkingDay = day['value'] as bool;
    final times = day['times'] as List<WorkTime>?;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 16.h, bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.border,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayTitle(dayKey, isWorkingDay, times),
          Gap(16.w),
          Expanded(child: _buildDayContent(context, isWorkingDay, times)),
        ],
      ),
    );
  }

  Widget _buildDayTitle(String dayKey, bool isWorkingDay, List<WorkTime>? times) {
    final isActive = isWorkingDay;
    
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.darkBlue02.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        dayKey.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyles.tajawal14W700.copyWith(
          color: isActive ? AppColors.darkBlue02 : Colors.red,
        ),
      ),
    );
  }

  Widget _buildDayContent(BuildContext context, bool isWorkingDay, List<WorkTime>? times) {
    if (!isWorkingDay) {
      return _buildClosedDayRow();
    }

    if (times == null || times.isEmpty) {
      return _buildCallBranchRow();
    }

    if (times.length == 1) {
      return _buildTimeSlot(context, times.first);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: times.map((time) => _buildTimeSlot(context, time)).toList(),
    );
  }

  Widget _buildClosedDayRow() {
    return Row(
      children: [
        Icon(
          Icons.close_rounded,
          color: Colors.red.withOpacity(0.6),
          size: 18.sp,
        ),
        Gap(8.w),
        Text(
          'branch_closed_day'.tr(),
          style: AppTextStyles.tajawal14W400.copyWith(
            color: theme.colorScheme.text100,
          ),
        ),
      ],
    );
  }

  Widget _buildCallBranchRow() {
    return Row(
      children: [
        Icon(
          Icons.phone_rounded,
          color: theme.colorScheme.text60,
          size: 18.sp,
        ),
        Gap(8.w),
        Expanded(
          child: Text(
            'call_branch_schedule'.tr(),
            style: AppTextStyles.tajawal14W400.copyWith(
              color: theme.colorScheme.text100,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(BuildContext context, WorkTime time) {
    final fromTime = _formatTime12Hour(time.fromTime ?? '', context);
    final toTime = _formatTime12Hour(time.toTime ?? '', context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: theme.colorScheme.text60,
            size: 18.sp,
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              '$fromTime ${'to'.tr()} $toTime',
              style: AppTextStyles.tajawal14W400.copyWith(
                color: theme.colorScheme.text100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime12Hour(String time24Hour, BuildContext context) {
    if (time24Hour.isEmpty) return time24Hour;
    
    try {
      final parts = time24Hour.split(':');
      if (parts.length != 2) return time24Hour;
      
      final hours = int.parse(parts[0]);
      final minutes = parts[1];
      final isArabic = EasyLocalization.of(context)?.locale.languageCode == 'ar';
      
      if (hours == 0) return isArabic ? '12:$minutes صباحاً' : '12:$minutes AM';
      if (hours < 12) return isArabic ? '${hours}:$minutes صباحاً' : '${hours}:$minutes AM';
      if (hours == 12) return isArabic ? '12:$minutes مساءً' : '12:$minutes PM';
      
      return isArabic ? '${hours - 12}:$minutes مساءً' : '${hours - 12}:$minutes PM';
    } catch (e) {
      return time24Hour;
    }
  }
}
