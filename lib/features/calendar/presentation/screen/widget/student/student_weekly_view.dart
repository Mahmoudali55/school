import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_event_widgets.dart';

class StudentWeeklyView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<StudentCalendarEvent> Function(DateTime) getEventsForDay;
  final String Function(int) getDayName;
  final bool Function(DateTime, DateTime) isSameDay;
  final List<StudentCalendarEvent> upcomingEvents;

  const StudentWeeklyView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.getEventsForDay,
    required this.getDayName,
    required this.isSameDay,
    required this.upcomingEvents,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildWeekDays(context),
          SizedBox(height: 20.h),
          _buildUpcomingEventsSection(context),
        ],
      ),
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));

    return Column(
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        List<StudentCalendarEvent> dayEvents = getEventsForDay(day);
        bool isToday = isSameDay(day, DateTime.now());
        bool isSelected = isSameDay(day, selectedDate);

        return GestureDetector(
          onTap: () => onDateSelected(day),
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : isToday
                    ? const Color(0xFF4CAF50).withOpacity(0.3)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
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
                  width: 40.w,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        getDayName(day.weekday),
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: const Color(0xFF6B7280)),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${day.day}',
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dayEvents
                        .take(3)
                        .map(
                          (event) => Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: event.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    event.title,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: const Color(0xFF1F2937)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  event.time,
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(fontSize: 10.sp, color: const Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUpcomingEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.upcoming.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
            ),
            Text(
              AppLocalKay.show_all.tr(),
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: const Color(0xFF4CAF50), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (upcomingEvents.isEmpty)
          const StudentEmptyState()
        else
          Column(
            children: upcomingEvents
                .take(5)
                .map((event) => StudentUpcomingEventItem(event: event))
                .toList(),
          ),
      ],
    );
  }
}
