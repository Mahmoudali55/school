import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
}
