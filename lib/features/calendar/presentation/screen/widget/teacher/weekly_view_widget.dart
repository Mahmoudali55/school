import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class WeeklyViewWidget extends StatelessWidget {
  const WeeklyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildWeekTimetable(state, context: context),
              SizedBox(height: 20.h),
              _buildWeeklyTasks(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekTimetable(CalendarState state, {required BuildContext context}) {
    final startOfWeek = state.selectedDate.subtract(Duration(days: state.selectedDate.weekday % 7));

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... باقي كود الجدول الأسبوعي
          // (يمكنك استخدام نفس الكود السابق مع تعديلاته)
        ],
      ),
    );
  }

  Widget _buildWeeklyTasks(CalendarState state) {
    // ... كود المهام الأسبوعية
    return Container();
  }
}
