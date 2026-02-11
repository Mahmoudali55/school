import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_weekly_view.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';

import '../../data/model/Events_response_model.dart';

class CalendarPatentScreen extends StatefulWidget {
  const CalendarPatentScreen({super.key});

  @override
  State<CalendarPatentScreen> createState() => _CalendarPatentScreenState();
}

class _CalendarPatentScreenState extends State<CalendarPatentScreen> {
  String _selectedStudent = "";
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final homeState = context.read<HomeCubit>().state;
    if (homeState.parentsStudentStatus.isSuccess) {
      final students = homeState.parentsStudentStatus.data!;
      if (students.isNotEmpty) {
        _isInitialized = true;
        _selectedStudent = students.first.studentName;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CalendarCubit>().changeStudent(students.first.classCode);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, homeState) {
            if (homeState.parentsStudentStatus.isSuccess && !_isInitialized) {
              final students = homeState.parentsStudentStatus.data!;
              if (students.isNotEmpty) {
                _isInitialized = true;
                _selectedStudent = students.first.studentName;
                context.read<ProfileCubit>().StudentProfile(students.first.studentCode);
              }
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, profileState) {
            if (profileState.studentProfileStatus.isSuccess) {
              final profile = profileState.studentProfileStatus.data!;
              final classInfo = ClassInfo(
                id: profile.classCode.toString(),
                name: profile.className,
                grade: profile.levelName,
                specialization: profile.className,
              );
              context.read<CalendarCubit>().emit(
                context.read<CalendarCubit>().state.copyWith(
                  classesStatus: StatusState.success([classInfo]),
                  selectedClass: classInfo,
                ),
              );
              context.read<CalendarCubit>().getEvents();
            }
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, homeState) {
          return BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, calendarState) {
              final calendarCubit = context.read<CalendarCubit>();
              List<String> studentNames = [];

              if (homeState.parentsStudentStatus.isSuccess) {
                final students = homeState.parentsStudentStatus.data!;
                for (var s in students) {
                  studentNames.add(s.studentName);
                }

                if (studentNames.isNotEmpty && _selectedStudent.isEmpty) {
                  _selectedStudent = studentNames.first;
                }
              }

              return Scaffold(
                backgroundColor: AppColor.whiteColor(context),
                body: SafeArea(
                  child: Column(
                    children: [
                      ParentCalendarHeader(
                        selectedDate: calendarState.selectedDate,
                        getFormattedDate: _getFormattedDate,
                      ),
                      ParentCalendarControlBar(
                        selectedStudent: _selectedStudent,
                        students: studentNames,
                        currentView: calendarState.currentView.index,
                        onStudentChanged: (studentName) {
                          setState(() {
                            _selectedStudent = studentName;
                          });
                          final student = homeState.parentsStudentStatus.data!.firstWhere(
                            (s) => s.studentName == studentName,
                          );
                          context.read<ProfileCubit>().StudentProfile(student.studentCode);
                        },
                        onViewSelected: (index) =>
                            calendarCubit.changeView(CalendarView.values[index]),
                        onPrevious: calendarCubit.goToPrevious,
                        onNext: calendarCubit.goToNext,
                      ),
                      if (homeState.parentsStudentStatus.isLoading) const LinearProgressIndicator(),
                      Expanded(
                        child: _buildCalendarContent(calendarState, calendarCubit, studentNames),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCalendarContent(
    CalendarState state,
    CalendarCubit cubit,
    List<String> studentNames,
  ) {
    switch (state.currentView) {
      case CalendarView.monthly:
        return ParentMonthlyView(
          selectedDate: state.selectedDate,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToParentEvents(state.getEventsForDay(day)),
          getEventsForMonth: (month) => _mapToParentEvents(state.getEventsForMonth(month)),
          upcomingEvents: _mapToParentEvents(state.getEventsForMonth(state.selectedDate)),
        );
      case CalendarView.weekly:
        return ParentWeeklyView(
          selectedDate: state.selectedDate,
          students: studentNames,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToParentEvents(state.getEventsForDay(day)),
          getEventsForStudent: (student) =>
              _mapToParentEvents(state.getEventsForDay(state.selectedDate)), // Simplified
          getDayName: _getDayName,
          isSameDay: _isSameDay,
        );
      case CalendarView.daily:
        return ParentDailyView(
          selectedDate: state.selectedDate,
          dailyEvents: _mapToParentEvents(state.getEventsForDay(state.selectedDate)),
          getFormattedDate: _getFormattedDate,
        );
      default:
        return ParentMonthlyView(
          selectedDate: state.selectedDate,
          onDateSelected: cubit.changeDate,
          getEventsForDay: (day) => _mapToParentEvents(state.getEventsForDay(day)),
          getEventsForMonth: (month) => _mapToParentEvents(state.getEventsForMonth(month)),
          upcomingEvents: _mapToParentEvents(state.getEventsForMonth(state.selectedDate)),
        );
    }
  }

  String _getFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'ar').format(date);
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<ParentCalendarEvent> _mapToParentEvents(List<dynamic> events) {
    return events.map((e) {
      if (e is Event) {
        return ParentCalendarEvent(
          title: e.eventTitel,
          date: e.eventDate,
          time: e.eventTime,
          type: "حدث",
          color: Color(int.tryParse(e.eventColore.replaceFirst('#', '0xFF')) ?? 0xFF10B981),
          location: "",
          description: e.eventDesc,
          student: _selectedStudent,
        );
      }
      return ParentCalendarEvent(
        title: "حدث غير معروف",
        date: "",
        time: "",
        type: "",
        color: Colors.grey,
        location: "",
        description: "",
        student: "",
      );
    }).toList();
  }
}
