import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';
import 'upcoming_tasks_widget.dart';

class MonthlyViewWidget extends StatelessWidget {
  const MonthlyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildTableCalendar(context, state),
              SizedBox(height: 20.h),
              // MonthlyStatsWidget(selectedDate: state.selectedDate),
              SizedBox(height: 20.h),
              const UpcomingTasksWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableCalendar(BuildContext context, CalendarState state) {
    return Container(
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
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: state.selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, state.selectedDate),
        onDaySelected: (selectedDay, focusedDay) {
          context.read<CalendarCubit>().changeDate(selectedDay);
        },
        onPageChanged: (focusedDay) {
          context.read<CalendarCubit>().changeDate(focusedDay);
        },
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.saturday,
        locale: context.locale.languageCode,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(color: const Color(0xFFFF9800), shape: BoxShape.circle),
          todayDecoration: BoxDecoration(
            color: const Color(0xFFFF9800).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF9800), width: 1.5),
          ),
          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          outsideDecoration: const BoxDecoration(shape: BoxShape.circle),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          leftChevronIcon: Icon(Icons.chevron_right_rounded, color: const Color(0xFFFF9800)),
          rightChevronIcon: Icon(Icons.chevron_left_rounded, color: const Color(0xFFFF9800)),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyle.bodySmall(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF6B7280)),
          weekendStyle: AppTextStyle.bodySmall(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFFFF9800)),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            // we will only show markers for the selected day since the API only returns events for one day at a time
            if (isSameDay(date, state.selectedDate) &&
                state.getEventsStatus.isSuccess &&
                state.getEventsStatus.data != null) {
              final apiEvents = state.getEventsStatus.data!.events;
              if (apiEvents.isNotEmpty) {
                return Positioned(
                  bottom: 2,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: apiEvents
                        .take(3)
                        .map(
                          (event) => Container(
                            width: 6.w,
                            height: 6.w,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: _getColorFromString(event.eventColore),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
            }
            return null;
          },
        ),
      ),
    );
  }

  Color _getColorFromString(String colorStr) {
    switch (colorStr.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.yellow;
      default:
        // Handle hex if provided
        if (colorStr.startsWith('#')) {
          try {
            return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
          } catch (e) {
            return Colors.grey;
          }
        }
        return Colors.grey;
    }
  }
}
