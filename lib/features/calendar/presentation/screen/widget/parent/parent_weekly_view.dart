import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';

class ParentWeeklyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> students;
  final Function(DateTime) onDateSelected;
  final List<ParentCalendarEvent> Function(DateTime) getEventsForDay;
  final List<ParentCalendarEvent> Function(String) getEventsForStudent;
  final String Function(int) getDayName;
  final bool Function(DateTime, DateTime) isSameDay;

  const ParentWeeklyView({
    super.key,
    required this.selectedDate,
    required this.students,
    required this.onDateSelected,
    required this.getEventsForDay,
    required this.getEventsForStudent,
    required this.getDayName,
    required this.isSameDay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildWeekDays(context),
          SizedBox(height: 20.h),
          _buildChildrenSchedule(context),
        ],
      ),
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    DateTime startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday % 7),
    );

    return Column(
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        List<ParentCalendarEvent> dayEvents = getEventsForDay(day);
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
                    ? const Color(0xFF2196F3)
                    : isToday
                    ? const Color(0xFF2196F3).withOpacity(0.3)
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
                        style: AppTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dayEvents
                        .take(2)
                        .map(
                          (event) => Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    color: event.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 8.w,
                                    color: AppColor.whiteColor(context),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    event.title,
                                    style: AppTextStyle.bodySmall(context)
                                        .copyWith(
                                          color: const Color(0xFF1F2937),
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  event.time,
                                  style: AppTextStyle.bodySmall(context)
                                      .copyWith(
                                        fontSize: 10.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (dayEvents.length > 2)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${dayEvents.length - 2}',
                      style: AppTextStyle.bodySmall(context).copyWith(
                        fontSize: 10.sp,
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChildrenSchedule(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalKay.child_schedule.tr(),
                style: AppTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${students.length} أبناء",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 11.sp,
                    color: const Color(0xFF2196F3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(
            children: students
                .map((student) => _buildChildSchedule(context, student))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSchedule(BuildContext context, String studentName) {
    List<ParentCalendarEvent> studentEvents = getEventsForStudent(studentName);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 14.w,
                  color: const Color(0xFF2196F3),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                studentName,
                style: AppTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${studentEvents.length} حدث",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 10.sp,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (studentEvents.isEmpty)
            _buildEmptySchedule(context)
          else
            Column(
              children: studentEvents
                  .take(3)
                  .map((event) => _buildScheduleItem(context, event))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, ParentCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${event.date} • ${event.time}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 10.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.type,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 9.sp,
                color: event.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 16.w,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(width: 8.w),
          Text(
            AppLocalKay.no_events_this_week.tr(),
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
