import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class WorkingHoursWidget extends StatelessWidget {
  final WorkTimes? workTimes;
  final WorkDays? workDays;
  final ThemeData theme;

  const WorkingHoursWidget({
    super.key,
    required this.workTimes,
    required this.workDays,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (workTimes == null && workDays == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'working_hours'.tr(),
          style: AppTextStyles.tajawal18W700.copyWith(
            color: theme.colorScheme.text100,
          ),
        ),
        Gap(16.h),
        _buildWorkingDaysGrid(),
        if (workTimes != null) ...[
          Gap(16.h),
          _buildWorkingTimesDetails(),
        ],
      ],
    );
  }

  Widget _buildWorkingDaysGrid() {
    if (workDays == null) return const SizedBox.shrink();

    final days = [
      {'key': 'sunday', 'value': workDays!.sunday, 'icon': Icons.schedule},
      {'key': 'monday', 'value': workDays!.monday, 'icon': Icons.schedule},
      {'key': 'tuesday', 'value': workDays!.tuesday, 'icon': Icons.schedule},
      {'key': 'wednesday', 'value': workDays!.wednesday, 'icon': Icons.schedule},
      {'key': 'thursday', 'value': workDays!.thursday, 'icon': Icons.schedule},
      {'key': 'friday', 'value': workDays!.friday, 'icon': Icons.schedule},
      {'key': 'saturday', 'value': workDays!.saturday, 'icon': Icons.schedule},
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: days
          .where((day) => day['value'] == true)
          .map((day) => _buildDayChip(day['key'] as String, day['icon'] as IconData))
          .toList(),
    );
  }

  Widget _buildDayChip(String dayKey, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlue02,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.darkBlue02,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.border00,
            size: 16.sp,
          ),
          Gap(6.w),
          Text(
            dayKey.tr(),
            style: AppTextStyles.tajawal14W700.copyWith(
              color: AppColors.border00,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingTimesDetails() {
    if (workTimes == null) return const SizedBox.shrink();

    final days = [
      {'key': 'sunday', 'times': workTimes!.sunday, 'icon': Icons.schedule},
      {'key': 'monday', 'times': workTimes!.monday, 'icon': Icons.schedule},
      {'key': 'tuesday', 'times': workTimes!.tuesday, 'icon': Icons.schedule},
      {'key': 'wednesday', 'times': workTimes!.wednesday, 'icon': Icons.schedule},
      {'key': 'thursday', 'times': workTimes!.thursday, 'icon': Icons.schedule},
      {'key': 'friday', 'times': workTimes!.friday, 'icon': Icons.schedule},
      {'key': 'saturday', 'times': workTimes!.saturday, 'icon': Icons.schedule},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'detailed_schedule'.tr(),
          style: AppTextStyles.tajawal16W500.copyWith(
            color: theme.colorScheme.text100,
          ),
        ),
        Gap(12.h),
        ...days
            .where((day) => day['times'] != null && (day['times'] as List<WorkTime>).isNotEmpty)
            .map((day) => _buildDayTimeSlot(
                  day['key'] as String,
                  day['times'] as List<WorkTime>,
                  day['icon'] as IconData,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildDayTimeSlot(String dayKey, List<WorkTime> times, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.border00.withOpacity(0.1),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.darkBlue02,
                size: 18.sp,
              ),
              Gap(8.w),
              Text(
                dayKey.tr(),
                style: AppTextStyles.tajawal18W700.copyWith(
                  color: theme.colorScheme.text100,
                ),
              ),
            ],
          ),
          Gap(8.h),
          ...times.map((time) => _buildTimeRange(time)).toList(),
        ],
      ),
    );
  }

  Widget _buildTimeRange(WorkTime time) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlue02.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.darkBlue02,
            size: 16.sp,
          ),
          Gap(8.w),
          Text(
            time.timeRange ?? '${time.fromTime} - ${time.toTime}',
            style: AppTextStyles.tajawal14W500.copyWith(
              color: AppColors.darkBlue02,
            ),
          ),
        ],
      ),
    );
  }
}
