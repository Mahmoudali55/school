import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';

class MonthlyView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<AdminCalendarEvent> Function(DateTime) getEventsForDay;
  final List<AdminCalendarEvent> Function(DateTime) getEventsForMonth;
  final List<AdminCalendarEvent> upcomingEvents;

  const MonthlyView({
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
          Gap(8.h),
          // شبكة الأيام
          _buildMonthGrid(context),
          Gap(20.h),
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
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF9C27B0)),
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

        List<AdminCalendarEvent> dayEvents = getEventsForDay(
          DateTime(selectedDate.year, selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => onDateSelected(DateTime(selectedDate.year, selectedDate.month, dayNumber)),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF9C27B0)
                  : isToday
                  ? const Color(0xFF9C27B0).withOpacity(0.1)
                  : AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFF9C27B0) : Colors.transparent,
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
                Gap(2.h),
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

  Widget _buildUpcomingEvents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.upcoming_events.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        Gap(12.h),
        ...upcomingEvents.map((event) => _buildUpcomingEventItem(context, event)).toList(),
      ],
    );
  }

  Widget _buildUpcomingEventItem(BuildContext context, AdminCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
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
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(color: event.color, borderRadius: BorderRadius.circular(2)),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                ),
                Gap(4.h),
                Text(
                  "${event.date} • ${event.time}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              event.type,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 10.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
