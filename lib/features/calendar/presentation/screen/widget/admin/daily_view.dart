import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/event_widgets.dart';

class DailyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<AdminCalendarEvent> dailyEvents;
  final Function(DateTime) onDateSelected;
  final String Function(DateTime) getFormattedDate;

  const DailyView({
    super.key,
    required this.selectedDate,
    required this.dailyEvents,
    required this.onDateSelected,
    required this.getFormattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قائمة الأحداث
          if (dailyEvents.isEmpty)
            const CalendarEmptyState()
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: dailyEvents.map((event) => EventCard(event: event)).toList(),
            ),
        ],
      ),
    );
  }
}
