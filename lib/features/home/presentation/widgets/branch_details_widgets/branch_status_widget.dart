import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

class BranchStatusWidget extends StatelessWidget {
  final WorkTimes? workTimes;
  final WorkDays? workDays;

  const BranchStatusWidget({
    super.key,
    required this.workTimes,
    required this.workDays,
  });

  @override
  Widget build(BuildContext context) {
    if (workTimes == null && workDays == null) {
      return const SizedBox.shrink();
    }

    final status = _getBranchStatus(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status.type).withOpacity(0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status.type),
            color: _getStatusColor(status.type),
            size: 14.sp,
          ),
          Gap(6.w),
          Flexible(
            child: Text(
              '${status.title} ${status.subtitle}',
              style: AppTextStyles.tajawal12W500.copyWith(
                color: _getStatusColor(status.type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BranchStatus _getBranchStatus(BuildContext context) {
    final now = DateTime.now();
    final currentDay = _getDayOfWeek(now.weekday);
    final currentTime = _formatCurrentTime(now);
    
    if (workDays == null) {
      return _createMaybeOpenStatus();
    }

    final isWorkingDay = _isWorkingDay(currentDay);
    
    if (!isWorkingDay) {
      final nextOpening = _getNextOpeningTime(context, now);
      return _createClosedStatus(nextOpening);
    }

    final dayTimes = _getDayTimes(currentDay);
    
    if (_hasNoWorkingTimes(dayTimes)) {
      return _createMaybeOpenStatus();
    }

    final isCurrentlyOpen = _isCurrentlyOpen(dayTimes!, currentTime);

    if (isCurrentlyOpen) {
      final closingTime = _getClosingTime(dayTimes!, currentTime, context);
      return _createOpenStatus(closingTime);
    }

    final nextOpening = _getNextOpeningTime(context, now);
    return _createClosedStatus(nextOpening);
  }

  String _formatCurrentTime(DateTime now) {
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  bool _hasNoWorkingTimes(List<WorkTime>? dayTimes) {
    return workTimes == null || dayTimes == null || dayTimes.isEmpty;
  }

  bool _isCurrentlyOpen(List<WorkTime> dayTimes, String currentTime) {
    return dayTimes.any((time) => 
      _isTimeInRange(currentTime, time.fromTime ?? '', time.toTime ?? '')
    );
  }

  BranchStatus _createMaybeOpenStatus() {
    return BranchStatus(
      type: StatusType.maybeOpen,
      title: 'branch_maybe_open_today'.tr(),
      subtitle: 'call_branch_confirm'.tr(),
    );
  }

  BranchStatus _createClosedStatus(String? nextOpening) {
    return BranchStatus(
      type: StatusType.closed,
      title: 'branch_closed_until'.tr(),
      subtitle: nextOpening ?? 'check_schedule'.tr(),
    );
  }

  BranchStatus _createOpenStatus(String closingTime) {
    return BranchStatus(
      type: StatusType.open,
      title: 'branch_open_now'.tr(),
      subtitle: 'closes_at'.tr(args: [closingTime]),
    );
  }

  String _getDayOfWeek(int weekday) {
    const dayNames = [
      'sunday', 'monday', 'tuesday', 'wednesday', 
      'thursday', 'friday', 'saturday'
    ];
    return dayNames[weekday % 7];
  }

  bool _isWorkingDay(String day) {
    if (workDays == null) return false;
    
    switch (day) {
      case 'monday': return workDays!.monday == true;
      case 'tuesday': return workDays!.tuesday == true;
      case 'wednesday': return workDays!.wednesday == true;
      case 'thursday': return workDays!.thursday == true;
      case 'friday': return workDays!.friday == true;
      case 'saturday': return workDays!.saturday == true;
      case 'sunday': return workDays!.sunday == true;
      default: return false;
    }
  }

  List<WorkTime>? _getDayTimes(String day) {
    if (workTimes == null) return null;
    
    switch (day) {
      case 'monday': return workTimes!.monday;
      case 'tuesday': return workTimes!.tuesday;
      case 'wednesday': return workTimes!.wednesday;
      case 'thursday': return workTimes!.thursday;
      case 'friday': return workTimes!.friday;
      case 'saturday': return workTimes!.saturday;
      case 'sunday': return workTimes!.sunday;
      default: return null;
    }
  }

  bool _isTimeInRange(String currentTime, String fromTime, String toTime) {
    if (fromTime.isEmpty || toTime.isEmpty) return false;
    
    final current = _timeToMinutes(currentTime);
    final from = _timeToMinutes(fromTime);
    final to = _timeToMinutes(toTime);
    
    if (from <= to) {
      return current >= from && current <= to;
    } else {
      return current >= from || current <= to;
    }
  }

  String _getClosingTime(List<WorkTime> dayTimes, String currentTime, BuildContext context) {
    final current = _timeToMinutes(currentTime);
    
    for (final time in dayTimes) {
      if (time.fromTime != null && time.toTime != null) {
        final from = _timeToMinutes(time.fromTime!);
        final to = _timeToMinutes(time.toTime!);
        
        if (_isTimeInRange(currentTime, time.fromTime!, time.toTime!)) {
          return _formatTime12Hour(time.toTime!, context);
        }
      }
    }
    
    return '';
  }

  String? _getNextOpeningTime(BuildContext context, DateTime now) {
    if (workDays == null) return null;
    
    final currentDay = now.weekday;
    final currentTime = _timeToMinutes(_formatCurrentTime(now));
    final nextDays = _getNextDaysToCheck(currentDay);
    
    // Try to find specific opening times if available
    if (workTimes != null) {
      final specificTime = _findSpecificOpeningTime(currentDay, currentTime, nextDays, context);
      if (specificTime != null) return specificTime;
    }
    
    // Fallback to just the day name if no times available
    return _findNextWorkingDay(nextDays);
  }

  List<int> _getNextDaysToCheck(int currentDay) {
    final days = <int>[];
    for (int i = 1; i < 7; i++) {
      int checkDay = (currentDay + i) % 7;
      if (checkDay == 0) checkDay = 7;
      days.add(checkDay);
    }
    return days;
  }

  String? _findSpecificOpeningTime(
    int currentDay, 
    int currentTime, 
    List<int> nextDays, 
    BuildContext context
  ) {
    // Check today first for later times
    final todayName = _getDayOfWeek(currentDay);
    if (_isWorkingDay(todayName)) {
      final todayTimes = _getDayTimes(todayName);
      if (todayTimes != null && todayTimes.isNotEmpty) {
        for (final time in todayTimes) {
          if (time.fromTime != null) {
            final fromTimeMinutes = _timeToMinutes(time.fromTime!);
            if (fromTimeMinutes > currentTime) {
              return _formatTime12Hour(time.fromTime!, context);
            }
          }
        }
      }
    }
    
    // Check next working days
    for (final checkDay in nextDays) {
      final dayName = _getDayOfWeek(checkDay);
      if (_isWorkingDay(dayName)) {
        final dayTimes = _getDayTimes(dayName);
        if (dayTimes != null && dayTimes.isNotEmpty) {
          final firstTime = dayTimes.first;
          if (firstTime.fromTime != null) {
            return '${dayName.tr()} ${_formatTime12Hour(firstTime.fromTime!, context)}';
          }
        }
      }
    }
    
    return null;
  }

  String? _findNextWorkingDay(List<int> nextDays) {
    for (final checkDay in nextDays) {
      final dayName = _getDayOfWeek(checkDay);
      if (_isWorkingDay(dayName)) {
        return dayName.tr();
      }
    }
    return null;
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    
    return hours * 60 + minutes;
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

  Color _getStatusColor(StatusType type) {
    switch (type) {
      case StatusType.open: return Colors.green;
      case StatusType.closed: return Colors.red;
      case StatusType.maybeOpen: return Colors.blue;
    }
  }

  IconData _getStatusIcon(StatusType type) {
    switch (type) {
      case StatusType.open: return Icons.check_circle_rounded;
      case StatusType.closed: return Icons.schedule_rounded;
      case StatusType.maybeOpen: return Icons.help_outline_rounded;
    }
  }
}

class BranchStatus {
  final StatusType type;
  final String title;
  final String subtitle;

  const BranchStatus({
    required this.type,
    required this.title,
    required this.subtitle,
  });
}

enum StatusType {
  open,
  closed,
  maybeOpen,
}
