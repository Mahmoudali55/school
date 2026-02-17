import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/Events_response_model.dart' as school;
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/weekly_view.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

class AdminCalendarScreen extends StatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  State<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends State<AdminCalendarScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data for management
    context.read<ClassCubit>().sectionData(userId: HiveMethods.getType());
  }

  final List<String> _filters = [
    AppLocalKay.filter_all.tr(),
    AppLocalKay.school_events.tr(),
    AppLocalKay.school_activities.tr(),
    AppLocalKay.school_exams.tr(),
    AppLocalKay.school_holidays.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClassCubit, ClassState>(
          listener: (context, classState) {
            if (classState.classDataStatus != null && classState.classDataStatus!.isSuccess) {
              final classes = classState.classDataStatus!.data!;
              final classInfoList = classes.map((c) {
                return ClassInfo(
                  id: c.classCode.toString(),
                  name: c.classNameAr,
                  grade: c.levelCode.toString(),
                  specialization: c.classNameAr,
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
        ),
      ],
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, calendarState) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor(context),
            body: SafeArea(
              child: Column(
                children: [
                  CalendarHeader(
                    selectedDate: calendarState.selectedDate,
                    getFormattedDate: _getFormattedDate,
                  ),

                  // Selectors
                  _buildAdminSelectors(),
                  CalendarControlBar(
                    selectedFilter: AppLocalKay.filter_all.tr(), // Default for now
                    filters: _filters,
                    currentView: calendarState.currentView.index,
                    onFilterSelected: (filter) {
                      // Handle filter
                    },
                    onViewSelected: (index) {
                      context.read<CalendarCubit>().changeView(CalendarView.values[index]);
                    },
                    onPrevious: () => context.read<CalendarCubit>().goToPrevious(),
                    onNext: () => context.read<CalendarCubit>().goToNext(),
                  ),
                  // عرض التقويم
                  Expanded(child: _buildCalendarContent(calendarState)),
                ],
              ),
            ),
            floatingActionButton: _buildFloatingActionButton(context),
          );
        },
      ),
    );
  }

  Widget _buildAdminSelectors() {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          color: AppColor.whiteColor(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section and Stage Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalKay.section.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap(4.h),
                        CustomDropdownFormField<SectionDataModel>(
                          hint: AppLocalKay.section.tr(),
                          value: state.selectedSection,
                          items: (state.sectionDataStatus.data ?? []).map((section) {
                            return DropdownMenuItem<SectionDataModel>(
                              value: section,
                              child: Text(section.sectionName),
                            );
                          }).toList(),
                          onChanged: (v) => context.read<ClassCubit>().onSectionChanged(v),
                          errorText: '',
                          submitted: false,
                        ),
                      ],
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.languageCode == 'ar' ? 'المرحلة' : 'Stage',
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap(4.h),
                        CustomDropdownFormField<StageDataModel>(
                          hint: context.locale.languageCode == 'ar'
                              ? 'اختر المرحلة'
                              : 'Select Stage',
                          value: state.selectedStage,
                          items: (state.stageDataStatus.data ?? []).map((stage) {
                            return DropdownMenuItem<StageDataModel>(
                              value: stage,
                              child: Text(stage.stageNameAr),
                            );
                          }).toList(),
                          onChanged: (v) => context.read<ClassCubit>().onStageChanged(v),
                          errorText: '',
                          submitted: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(12.h),
              // Level and Class Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalKay.level.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap(4.h),
                        CustomDropdownFormField<LevelModel>(
                          hint: AppLocalKay.level.tr(),
                          value: state.selectedLevel,
                          items: (state.levelDataStatus?.data ?? []).map((level) {
                            return DropdownMenuItem<LevelModel>(
                              value: level,
                              child: Text(level.levelName),
                            );
                          }).toList(),
                          onChanged: (v) => context.read<ClassCubit>().onLevelChanged(v),
                          errorText: '',
                          submitted: false,
                        ),
                      ],
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalKay.classes.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap(4.h),
                        BlocBuilder<CalendarCubit, CalendarState>(
                          builder: (context, calendarState) {
                            return CustomDropdownFormField<ClassInfo>(
                              hint: AppLocalKay.classes.tr(),
                              value: calendarState.selectedClass,
                              items: calendarState.classes.map((c) {
                                return DropdownMenuItem<ClassInfo>(value: c, child: Text(c.name));
                              }).toList(),
                              onChanged: (v) => context.read<CalendarCubit>().changeClass(v),
                              errorText: '',
                              submitted: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (state.classDataStatus?.isLoading ?? false)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: const Center(child: LinearProgressIndicator()),
                ),
            ],
          ),
        );
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
              child: AddEventScreen(color: Color(0xFF9C27B0), isManagement: true),
            ),
          ),
        );
      },
      backgroundColor: Color(0xFF9C27B0),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }

  Widget _buildCalendarContent(CalendarState state) {
    if (state.getEventsStatus.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.currentView) {
      case CalendarView.daily:
        final rawEvents = state.getEventsForDay(state.selectedDate);
        return DailyView(
          selectedDate: state.selectedDate,
          dailyEvents: rawEvents.map<AdminCalendarEvent>((e) => _toAdminEvent(e)).toList(),
          onDateSelected: (date) => context.read<CalendarCubit>().changeDate(date),
          getFormattedDate: _getFormattedDate,
          onEditEvent: (event) {},
          onSetReminder: (event) {},
          onShareEvent: (event) {},
        );
      case CalendarView.weekly:
        final startOfWeek = state.selectedDate.subtract(
          Duration(days: state.selectedDate.weekday % 7),
        );
        return WeeklyView(
          selectedDate: state.selectedDate,
          onDateSelected: (date) => context.read<CalendarCubit>().changeDate(date),
          getEventsForDay: (DateTime day) =>
              state.getEventsForDay(day).map<AdminCalendarEvent>((e) => _toAdminEvent(e)).toList(),
          getWeeklyEvents: () => state
              .getEventsForWeek(startOfWeek)
              .map<AdminCalendarEvent>((e) => _toAdminEvent(e))
              .toList(),
          getWeekNumber: _getWeekNumber,
          getDayName: _getDayName,
          isSameDay: _isSameDay,
        );
      case CalendarView.monthly:
        return MonthlyView(
          selectedDate: state.selectedDate,
          onDateSelected: (date) => context.read<CalendarCubit>().changeDate(date),
          getEventsForDay: (DateTime day) =>
              state.getEventsForDay(day).map<AdminCalendarEvent>((e) => _toAdminEvent(e)).toList(),
          getEventsForMonth: (DateTime month) => state
              .getEventsForMonth(month)
              .map<AdminCalendarEvent>((e) => _toAdminEvent(e))
              .toList(),
          upcomingEvents: state
              .getEventsForMonth(state.selectedDate)
              .take(5)
              .map<AdminCalendarEvent>((e) => _toAdminEvent(e))
              .toList(),
        );
    }
  }

  AdminCalendarEvent _toAdminEvent(dynamic event) {
    if (event is AdminCalendarEvent) return event;

    // Mapping from Event (School API)
    if (event is school.Event) {
      final colorStr = event.eventColore.replaceAll('#', '');
      Color color;
      try {
        color = Color(int.parse('FF$colorStr', radix: 16));
      } catch (e) {
        color = const Color(0xFF9C27B0);
      }

      final title = event.eventTitel;
      String type = "اجتماع"; // Default
      if (title.contains("اختبار") || title.contains("امتحان")) {
        type = "اختبار";
      } else if (title.contains("عطلة") || title.contains("إجازة")) {
        type = "عطلة";
      } else if (title.contains("فعالية") || title.contains("نشاط") || title.contains("حفل")) {
        type = "فعالية";
      }

      return AdminCalendarEvent(
        title: title,
        date: event.eventDate,
        time: event.eventTime.isEmpty ? "08:00 ص" : event.eventTime,
        type: type,
        color: color,
        location: '',
        description: event.eventDesc,
        participants: [],
        priority: "عادي",
      );
    }

    // Mapping from TeacherCalendarEvent (Local model)
    if (event is TeacherCalendarEvent) {
      String type = "اجتماع";
      switch (event.type) {
        case EventType.meeting:
          type = "اجتماع";
          break;
        case EventType.exam:
          type = "اختبار";
          break;
        case EventType.classEvent:
          type = "حصّة";
          break;
        case EventType.correction:
          type = "تصحيح";
          break;
        case EventType.preparation:
          type = "تحضير";
          break;
      }

      return AdminCalendarEvent(
        title: event.title,
        date: DateFormat('yyyy-MM-dd').format(event.date),
        time: event.formattedTime,
        type: type,
        color: event.color,
        location: event.location,
        description: event.description,
        participants: [],
        priority: event.status,
      );
    }

    // Fallback
    return AdminCalendarEvent(
      title: "حدث غير معروف",
      date: "",
      time: "",
      type: "غير محدد",
      color: Colors.grey,
      location: "",
      description: "",
      participants: [],
      priority: "",
    );
  }

  // دوال مساعدة
  String _getFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'en').format(date);
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  int _getWeekNumber(DateTime date) {
    int firstDay = DateTime(date.year, 1, 1).weekday;
    int days = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((days + firstDay - 1) / 7).floor() + 1;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
