import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calendar_header_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calender_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/daily_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/monthly_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/weekly_view_widget.dart';

class CalendarTeacherScreen extends StatelessWidget {
  const CalendarTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildCalendarContent() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
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
      onPressed: () => _showAddEventDialog(context),
      backgroundColor: AppColor.accentColor(context),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) => AlertDialog(
        backgroundColor: AppColor.whiteColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalKay.new_event.tr(), style: AppTextStyle.titleMedium(context)),
        content: Text(AppLocalKay.new_event_hint.tr(), style: AppTextStyle.bodyMedium(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.dialog_delete_cancel.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.primaryColor(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.add.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
