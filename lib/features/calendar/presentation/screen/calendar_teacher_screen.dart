import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calendar_header_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calender_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/daily_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/monthly_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/weekly_view_widget.dart';

class CalendarTeacherScreen extends StatelessWidget {
  const CalendarTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            const CalendarHeaderWidget(),
            // اختيار الصف وشريط التحكم
            const ControlBarWidget(),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildCalendarContent() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text(state.error!));
        }
        switch (state.currentView) {
          case CalendarView.monthly:
            return const MonthlyViewWidget();
          case CalendarView.weekly:
            return const WeeklyViewWidget();
          case CalendarView.daily:
            return const DailyViewWidget();
        }
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEventScreen(color: AppColor.accentColor(context))),
        );
      },
      backgroundColor: AppColor.accentColor(context),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }
}
