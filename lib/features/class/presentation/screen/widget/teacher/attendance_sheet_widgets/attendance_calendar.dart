import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const AttendanceCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.week,
        availableGestures: AvailableGestures.horizontalSwipe,
        headerVisible: false,
        daysOfWeekHeight: 30.h,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(
            color: AppColor.errorColor(context).withValues(alpha: 0.6),
            fontSize: 14.sp,
          ),
          defaultTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryColor(context),
                AppColor.primaryColor(context).withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor(context).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          todayDecoration: BoxDecoration(
            color: AppColor.primaryColor(context).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.primaryColor(context), width: 1),
          ),
          todayTextStyle: TextStyle(
            color: AppColor.primaryColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppColor.greyColor(context).withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          weekendStyle: TextStyle(
            color: AppColor.errorColor(context).withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
