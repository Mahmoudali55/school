import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/event_widgets.dart';

class DailyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<AdminCalendarEvent> dailyEvents;
  final Function(DateTime) onDateSelected;
  final String Function(DateTime) getFormattedDate;
  final Function(AdminCalendarEvent) onEditEvent;
  final Function(AdminCalendarEvent) onSetReminder;
  final Function(AdminCalendarEvent) onShareEvent;

  const DailyView({
    super.key,
    required this.selectedDate,
    required this.dailyEvents,
    required this.onDateSelected,
    required this.getFormattedDate,
    required this.onEditEvent,
    required this.onSetReminder,
    required this.onShareEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اليوم وتاريخه
          _buildDailyHeader(context, dailyEvents.length),
          Gap(16.h),
          // قائمة الأحداث
          if (dailyEvents.isEmpty)
            const CalendarEmptyState()
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: dailyEvents
                  .map(
                    (event) => EventCard(
                      event: event,
                      onEdit: () => onEditEvent(event),
                      onSetReminder: () => onSetReminder(event),
                      onShare: () => onShareEvent(event),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDailyHeader(BuildContext context, int eventCount) {
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
              color: const Color(0xFF9C27B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: const Color(0xFF9C27B0), size: 24.w),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(selectedDate),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                ),
                Gap(2.h),
                Text(
                  "$eventCount أحداث مجدولة لليوم",
                  style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
