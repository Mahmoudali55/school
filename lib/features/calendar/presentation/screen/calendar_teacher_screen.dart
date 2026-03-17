import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calendar_header_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/daily_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/monthly_view_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/weekly_view_widget.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
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
      final stageCode = int.parse(stageStr.toString());
      context.read<HomeCubit>().teacherLevel(stageCode);
    }
  }

  void _onLevelSelected(int levelCode) {
    setState(() {
      _selectedLevelCode = levelCode;
    });

    context.read<CalendarCubit>().changeLevel(levelCode);
  }

  @override

  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, homeState) {
        if (homeState.teacherLevelStatus.isSuccess && _selectedLevelCode == null) {
          final levels = homeState.teacherLevelStatus.data!;
          if (levels.isNotEmpty) {
            _onLevelSelected(levels.first.levelCode);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.scaffoldColor(context),
          body: Column(
            children: [
              // رأس الصفحة
              const CalendarHeaderWidget(),

              // عرض التقويم (الفلاتر والتحكم تم نقلهم لداخل كل عرض)
              Expanded(child: _buildCalendarContent()),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state.getEventsStatus.isLoading && state.getEventsStatus.isInitial) {
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
                BlocProvider.value(value: context.read<ClassCubit>()),
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
