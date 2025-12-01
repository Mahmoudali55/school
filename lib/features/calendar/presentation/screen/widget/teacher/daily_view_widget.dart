import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class DailyViewWidget extends StatelessWidget {
  const DailyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final dailyEvents = state.getEventsForDay(state.selectedDate);
        final dailyClasses = state.getDailyClasses(state.selectedDate);
        final dailyTasks = state.getDailyTasks(state.selectedDate);

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailyHeader(state, dailyEvents.length, context: context),
              SizedBox(height: 16.h),
              _buildDailyTimetable(dailyClasses, context),
              SizedBox(height: 20.h),
              _buildDailyTasks(dailyTasks),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyHeader(CalendarState state, int eventCount, {required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10.w),
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
              color: AppColor.accentColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: AppColor.accentColor(context), size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedDate(state.selectedDate),
                  style: AppTextStyle.bodyMedium(context, color: AppColor.blackColor(context)),
                ),
                SizedBox(height: 5.h),
                Text(
                  _getDayName(state.selectedDate.weekday),
                  style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$eventCount حدث",
                style: AppTextStyle.bodyMedium(context, color: AppColor.accentColor(context)),
              ),
              SizedBox(height: 2.h),
              Text(
                "${_getTeachingHours(state)} ساعة تدريس",
                style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context)),
              ),
            ],
          ),
        ],
      ),
    );
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

  String _getTeachingHours(CalendarState state) {
    final dailyClasses = state.getDailyClasses(state.selectedDate);
    double totalHours = 0;
    for (var classEvent in dailyClasses) {
      totalHours += classEvent.duration.inMinutes / 60;
    }
    return totalHours.toStringAsFixed(1);
  }

  Widget _buildDailyTimetable(List<TeacherCalendarEvent> dailyClasses, BuildContext context) {
    if (dailyClasses.isEmpty) {
      return _buildEmptySchedule(context);
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.whiteColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.schedule_title.tr(),
            style: AppTextStyle.titleMedium(context, color: Color(0xFF1F2937)),
          ),
          SizedBox(height: 12.h),
          Column(children: dailyClasses.map((classEvent) => _buildClassItem(classEvent)).toList()),
        ],
      ),
    );
  }

  Widget _buildClassItem(TeacherCalendarEvent classEvent) {
    // ... كود عرض الحصة الفردية
    return Container();
  }

  Widget _buildDailyTasks(List<TeacherCalendarEvent> dailyTasks) {
    // ... كود المهام اليومية
    return Container();
  }

  Widget _buildEmptySchedule(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 48.w, color: AppColor.greyColor(context)),
          SizedBox(height: 12.h),
          Text(AppLocalKay.schedule_empty_title.tr(), style: AppTextStyle.titleMedium(context)),
          SizedBox(height: 4.h),
          Text(
            AppLocalKay.schedule_empty_title2.tr(),
            style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}
