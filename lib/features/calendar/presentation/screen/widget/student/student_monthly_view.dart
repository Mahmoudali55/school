import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_event_widgets.dart';

class StudentMonthlyView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<StudentCalendarEvent> Function(DateTime) getEventsForDay;
  final List<StudentCalendarEvent> upcomingEvents;

  const StudentMonthlyView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.getEventsForDay,
    required this.upcomingEvents,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildDaysHeader(context),
          SizedBox(height: 8.h),
          _buildMonthGrid(context),
          SizedBox(height: 20.h),
          _buildUpcomingEventsSection(context),
        ],
      ),
    );
  }

  Widget _buildDaysHeader(BuildContext context) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];

    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF4CAF50)),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthGrid(BuildContext context) {
    DateTime firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    int startingWeekday = firstDay.weekday % 7;
    int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1.2,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        int dayNumber = index - startingWeekday + 1;
        bool isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
        bool isToday =
            isCurrentMonth &&
            dayNumber == DateTime.now().day &&
            selectedDate.month == DateTime.now().month &&
            selectedDate.year == DateTime.now().year;
        bool isSelected = isCurrentMonth && dayNumber == selectedDate.day;

        if (!isCurrentMonth) {
          return Container();
        }

        List<StudentCalendarEvent> dayEvents = getEventsForDay(
          DateTime(selectedDate.year, selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => onDateSelected(DateTime(selectedDate.year, selectedDate.month, dayNumber)),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : isToday
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFF4CAF50) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                if (dayEvents.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...dayEvents
                          .take(2)
                          .map(
                            (event) => Container(
                              width: 4.w,
                              height: 4.w,
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColor.whiteColor(context) : event.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      if (dayEvents.length > 2)
                        Text(
                          '+${dayEvents.length - 2}',
                          style: AppTextStyle.bodySmall(context).copyWith(
                            fontSize: 8.sp,
                            color: isSelected
                                ? AppColor.whiteColor(context)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
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
              AppLocalKay.upcoming_events.tr(),
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
