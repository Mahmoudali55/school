import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_weekly_view.dart';

import '../../data/model/Events_response_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final cubit = context.read<CalendarCubit>();
        return Scaffold(
          backgroundColor: AppColor.whiteColor(context),
          body: SafeArea(
            child: Column(
              children: [
                // رأس الصفحة
                StudentCalendarHeader(
                  selectedDate: state.selectedDate,
                  getFormattedDate: _getFormattedDate,
                ),
                // شريط التحكم
                StudentCalendarControlBar(
                  currentView: state.currentView.index,
                  onViewSelected: (index) => cubit.changeView(CalendarView.values[index]),
                  onPrevious: cubit.goToPrevious,
                  onNext: cubit.goToNext,
                ),
                // عرض التقويم
                Expanded(child: _buildCalendarContent(state, cubit)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarContent(CalendarState state, CalendarCubit cubit) {
    switch (state.currentView) {
      case CalendarView.monthly:
        return StudentMonthlyView(
          selectedDate: state.selectedDate,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToStudentEvents(state.getEventsForDay(day)),
          upcomingEvents: _mapToStudentEvents(state.getEventsForMonth(state.selectedDate)),
        );
      case CalendarView.weekly:
        return StudentWeeklyView(
          selectedDate: state.selectedDate,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToStudentEvents(state.getEventsForDay(day)),
          getDayName: _getDayName,
          isSameDay: _isSameDay,
          upcomingEvents: _mapToStudentEvents(state.getEventsForWeek(state.selectedDate)),
        );
      case CalendarView.daily:
        return StudentDailyView(
          selectedDate: state.selectedDate,
          dailyEvents: _mapToStudentEvents(state.getEventsForDay(state.selectedDate)),
          getFormattedDate: _getFormattedDate,
          getDayName: _getDayName,
        );
      default:
        return StudentMonthlyView(
          selectedDate: state.selectedDate,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToStudentEvents(state.getEventsForDay(day)),
          upcomingEvents: _mapToStudentEvents(state.getEventsForMonth(state.selectedDate)),
        );
    }
  }

  String _getFormattedDate(DateTime date) {
    List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<StudentCalendarEvent> _mapToStudentEvents(List<dynamic> events) {
    // Check if they are of type Event or something else
    return events.map((e) {
      if (e is Event) {
        return StudentCalendarEvent(
          title: e.eventTitel,
          date: e.eventDate,
          time: e.eventTime,
          type: "حدث",
          color: Color(int.tryParse(e.eventColore.replaceFirst('#', '0xFF')) ?? 0xFF10B981),
          location: "",
          description: e.eventDesc,
        );
      }
      return StudentCalendarEvent(
        title: "حدث غير معروف",
        date: "",
        time: "",
        type: "",
        color: Colors.grey,
        location: "",
        description: "",
      );
    }).toList();
  }
}
