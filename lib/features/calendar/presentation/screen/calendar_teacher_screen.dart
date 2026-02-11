import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
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
import 'package:my_template/features/home/data/models/teacher_level_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class CalendarTeacherScreen extends StatefulWidget {
  const CalendarTeacherScreen({super.key});

  @override
  State<CalendarTeacherScreen> createState() => _CalendarTeacherScreenState();
}

class _CalendarTeacherScreenState extends State<CalendarTeacherScreen> {
  int? _selectedLevelCode;
  int? _selectedSectionCode;
  int? _selectedStageCode;

  @override
  void initState() {
    super.initState();
    // Fetch teacher levels when screen initializes
    final stageStr = HiveMethods.getUserStage();
    final sectionStr = HiveMethods.getUserSection();

    if (stageStr != null && stageStr.toString().isNotEmpty) {
      _selectedStageCode = int.parse(stageStr.toString());
      context.read<HomeCubit>().teacherLevel(_selectedStageCode!);
    }

    if (sectionStr != null && sectionStr.toString().isNotEmpty) {
      _selectedSectionCode = int.parse(sectionStr.toString());
    }
  }

  void _onLevelSelected(int levelCode) {
    setState(() {
      _selectedLevelCode = levelCode;
    });

    // Fetch classes for the selected level
    if (_selectedSectionCode != null && _selectedStageCode != null) {
      context.read<HomeCubit>().teacherClasses(
        _selectedSectionCode!,
        _selectedStageCode!,
        levelCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, homeState) {
        if (homeState.teacherClassesStatus.isSuccess) {
          final teacherClasses = homeState.teacherClassesStatus.data!;
          final classInfoList = teacherClasses.map((tc) {
            return ClassInfo(
              id: tc.classCode.toString(),
              name: tc.classNameAr,
              grade: tc.levelCode.toString(),
              specialization: tc.classNameAr,
            );
          }).toList();

          context.read<CalendarCubit>().emit(
            context.read<CalendarCubit>().state.copyWith(
              classesStatus: StatusState.success(classInfoList),
              selectedClass: classInfoList.isNotEmpty ? classInfoList.first : null,
            ),
          );

          if (classInfoList.isNotEmpty) {
            context.read<CalendarCubit>().getEvents();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor(context),
        body: SafeArea(
          child: Column(
            children: [
              // رأس الصفحة
              const CalendarHeaderWidget(),

              // Level Dropdown
              _buildLevelSelector(),

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

  Widget _buildLevelSelector() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.teacherLevelStatus.isLoading) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.teacherLevelStatus.isFailure) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              state.teacherLevelStatus.error ?? "Error loading levels",
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.red),
            ),
          );
        }

        if (!state.teacherLevelStatus.isSuccess) {
          return const SizedBox.shrink();
        }

        final levels = state.teacherLevelStatus.data as List<TeacherLevelModel>;

        if (levels.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedLevelCode,
              hint: Text(AppLocalKay.level.tr(), style: AppTextStyle.bodySmall(context)),
              icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFFF9800)),
              isExpanded: true,
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  _onLevelSelected(newValue);
                }
              },
              items: levels.map<DropdownMenuItem<int>>((TeacherLevelModel level) {
                return DropdownMenuItem<int>(
                  value: level.levelCode,
                  child: Row(
                    children: [
                      Icon(Icons.school_outlined, size: 16.w, color: const Color(0xFFFF9800)),
                      SizedBox(width: 6.w),
                      Text(level.levelName),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
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
