import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calendar_header_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calender_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/daily_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/monthly_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/weekly_view_widget.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class CalendarTeacherScreen extends StatefulWidget {
  const CalendarTeacherScreen({super.key});

  @override
  State<CalendarTeacherScreen> createState() => _CalendarTeacherScreenState();
}

class _CalendarTeacherScreenState extends State<CalendarTeacherScreen> {
  int? _selectedLevelCode;

  @override
  void initState() {
    super.initState();
    // Fetch teacher levels when screen initializes
    final stageStr = HiveMethods.getUserStage();
    if (stageStr != null && stageStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherLevel(int.parse(stageStr.toString()));
    }
    // Also trigger initial load of classes (default level)
    // context.read<CalendarCubit>().loadTeacherClasses();
  }

  void _fetchClasses() {
    if (_selectedLevelCode != null) {
      context.read<CalendarCubit>().loadTeacherClasses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            const CalendarHeaderWidget(),

            // Level Dropdown
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                final levels = homeState.teacherLevelStatus.data ?? [];
                if (levels.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomDropdownFormField<int>(
                        value: levels.any((e) => e.levelCode == _selectedLevelCode)
                            ? _selectedLevelCode
                            : null,
                        hint: AppLocalKay.user_management_class.tr(),
                        items: levels
                            .map(
                              (e) => DropdownMenuItem(value: e.levelCode, child: Text(e.levelName)),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedLevelCode = v;
                          });
                          _fetchClasses();
                        },
                        errorText: '',
                        submitted: false,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              },
            ),

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
        if (state.getEventsStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.getEventsStatus.isFailure) {
          return Center(child: Text(state.getEventsStatus.error ?? "Error loading events"));
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
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<CalendarCubit>()),
                BlocProvider.value(value: context.read<HomeCubit>()),
              ],
              child: AddEventScreen(color: AppColor.accentColor(context)),
            ),
          ),
        );
      },
      backgroundColor: AppColor.accentColor(context),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }
}
