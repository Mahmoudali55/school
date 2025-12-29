import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_event_widgets.dart';

class StudentDailyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<StudentCalendarEvent> dailyEvents;
  final String Function(DateTime) getFormattedDate;
  final String Function(int) getDayName;

  const StudentDailyView({
    super.key,
    required this.selectedDate,
    required this.dailyEvents,
    required this.getFormattedDate,
    required this.getDayName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDailyHeader(context),
          SizedBox(height: 16.h),
          if (dailyEvents.isEmpty)
            const StudentEmptyState()
          else
            Column(
              children: dailyEvents
                  .map((event) => StudentEventCard(event: event))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDailyHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: const Color(0xFF4CAF50),
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(selectedDate),
                  style: AppTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  getDayName(selectedDate.weekday),
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Text(
            "${dailyEvents.length} حدث",
            style: AppTextStyle.bodySmall(context).copyWith(
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
