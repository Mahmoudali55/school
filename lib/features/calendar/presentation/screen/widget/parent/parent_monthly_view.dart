import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_event_widgets.dart';

class ParentMonthlyView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<ParentCalendarEvent> Function(DateTime) getEventsForDay;
  final List<ParentCalendarEvent> Function(DateTime) getEventsForMonth;
  final List<ParentCalendarEvent> upcomingEvents;

  const ParentMonthlyView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.getEventsForDay,
    required this.getEventsForMonth,
    required this.upcomingEvents,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // رأس الأيام
          _buildDaysHeader(context),
          SizedBox(height: 8.h),
          // شبكة الأيام
          _buildMonthGrid(context),
          SizedBox(height: 20.h),
          // ملخص الشهر
          _buildMonthlySummary(context),
          SizedBox(height: 20.h),
          // الأحداث القادمة
          _buildUpcomingEvents(context),
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
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF2196F3)),
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

        List<ParentCalendarEvent> dayEvents = getEventsForDay(
          DateTime(selectedDate.year, selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => onDateSelected(DateTime(selectedDate.year, selectedDate.month, dayNumber)),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2196F3)
                  : isToday
                  ? const Color(0xFF2196F3).withOpacity(0.1)
                  : AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFF2196F3) : Colors.transparent,
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

  Widget _buildMonthlySummary(BuildContext context) {
    List<ParentCalendarEvent> monthEvents = getEventsForMonth(selectedDate);

    Map<String, int> eventCounts = {};
    for (var event in monthEvents) {
      eventCounts[event.type] = (eventCounts[event.type] ?? 0) + 1;
    }

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
          Text(
            AppLocalKay.stats.tr(),
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                context,
                AppLocalKay.exams.tr(),
                eventCounts["امتحان"] ?? 0,
                const Color(0xFFDC2626),
              ),
              _buildSummaryItem(
                context,
                AppLocalKay.school_activities.tr(),
                eventCounts["فعالية"] ?? 0,
                const Color(0xFF10B981),
              ),
              _buildSummaryItem(
                context,
                AppLocalKay.meetings.tr(),
                eventCounts["اجتماع"] ?? 0,
                const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Text(
            '$count',
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_note_rounded, color: const Color(0xFF2196F3), size: 20.w),
            SizedBox(width: 8.w),
            Text(
              AppLocalKay.upcoming.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (upcomingEvents.isEmpty)
          const ParentEmptyState()
        else
          Column(children: upcomingEvents.map((event) => ParentEventCard(event: event)).toList()),
      ],
    );
  }
}
