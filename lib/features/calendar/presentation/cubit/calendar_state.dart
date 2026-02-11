import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/calendar/data/model/Events_response_model.dart';
import 'package:my_template/features/calendar/data/model/add_event_response_model.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/data/model/events_del_model.dart';

class CalendarState extends Equatable {
  /// UI State
  final DateTime selectedDate;
  final CalendarView currentView;
  final ClassInfo? selectedClass;

  /// Data Status
  final StatusState<List<ClassInfo>> classesStatus;
  final StatusState<List<TeacherCalendarEvent>> eventsStatus;
  final StatusState<AddEventResponseModel> addEventStatus;
  final StatusState<GetEventsResponse> getEventsStatus;
  final StatusState<AddEventResponseModel> editEventStatus;
  final StatusState<EventsDelModel> deleteEventStatus;

  const CalendarState({
    required this.selectedDate,
    required this.currentView,
    this.selectedClass,
    this.classesStatus = const StatusState.initial(),
    this.eventsStatus = const StatusState.initial(),
    this.addEventStatus = const StatusState.initial(),
    this.getEventsStatus = const StatusState.initial(),
    this.editEventStatus = const StatusState.initial(),
    this.deleteEventStatus = const StatusState.initial(),
  });

  /// Convenience Getters
  List<ClassInfo> get classes => classesStatus.data ?? const [];
  List<TeacherCalendarEvent> get events => eventsStatus.data ?? const [];

  @override
  List<Object?> get props => [
    selectedDate,
    currentView,
    selectedClass,
    classesStatus,
    eventsStatus,
    addEventStatus,
    getEventsStatus,
    editEventStatus,
    deleteEventStatus,
  ];

  CalendarState copyWith({
    DateTime? selectedDate,
    CalendarView? currentView,
    ClassInfo? selectedClass,
    StatusState<List<ClassInfo>>? classesStatus,
    StatusState<List<TeacherCalendarEvent>>? eventsStatus,
    StatusState<AddEventResponseModel>? addEventStatus,
    StatusState<GetEventsResponse>? getEventsStatus,
    StatusState<AddEventResponseModel>? editEventStatus,
    StatusState<EventsDelModel>? deleteEventStatus,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentView: currentView ?? this.currentView,
      selectedClass: selectedClass ?? this.selectedClass,
      classesStatus: classesStatus ?? this.classesStatus,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      addEventStatus: addEventStatus ?? this.addEventStatus,
      getEventsStatus: getEventsStatus ?? this.getEventsStatus,
      editEventStatus: editEventStatus ?? this.editEventStatus,
      deleteEventStatus: deleteEventStatus ?? this.deleteEventStatus,
    );
  }

  /* ================= Helpers ================= */

  List<dynamic> getEventsForDay(DateTime day) {
    final teacherEvents = events
        .where(
          (event) =>
              event.date.year == day.year &&
              event.date.month == day.month &&
              event.date.day == day.day,
        )
        .toList();

    final apiEventsList = getEventsStatus.data?.events ?? [];
    final apiEvents = apiEventsList
        .where(
          (event) =>
              event.date.year == day.year &&
              event.date.month == day.month &&
              event.date.day == day.day,
        )
        .toList();

    return [...teacherEvents, ...apiEvents];
  }

  List<dynamic> getEventsForWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final teacherEvents = events
        .where(
          (event) =>
              event.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              event.date.isBefore(endOfWeek.add(const Duration(days: 1))),
        )
        .toList();

    final apiEventsList = getEventsStatus.data?.events ?? [];
    final apiEvents = apiEventsList
        .where(
          (event) =>
              event.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              event.date.isBefore(endOfWeek.add(const Duration(days: 1))),
        )
        .toList();

    return [...teacherEvents, ...apiEvents];
  }

  List<dynamic> getEventsForMonth(DateTime month) {
    final teacherEvents = events
        .where((event) => event.date.year == month.year && event.date.month == month.month)
        .toList();

    final apiEventsList = getEventsStatus.data?.events ?? [];
    final apiEvents = apiEventsList
        .where((event) => event.date.year == month.year && event.date.month == month.month)
        .toList();

    return [...teacherEvents, ...apiEvents];
  }

  List<dynamic> getDailyClasses(DateTime day) {
    return getEventsForDay(day)
        .where((event) => event is TeacherCalendarEvent && event.type == EventType.classEvent)
        .toList();
  }

  List<dynamic> getDailyTasks(DateTime day) {
    return getEventsForDay(day)
        .where(
          (event) =>
              event is TeacherCalendarEvent &&
              (event.type == EventType.correction || event.type == EventType.preparation),
        )
        .toList();
  }

  Map<String, int> getMonthlyStats(DateTime month) {
    final monthEvents = getEventsForMonth(month);
    return {
      'classes': monthEvents
          .where((e) => e is TeacherCalendarEvent && e.type == EventType.classEvent)
          .length,
      'exams': monthEvents
          .where((e) => e is TeacherCalendarEvent && e.type == EventType.exam)
          .length,
      'meetings': monthEvents
          .where((e) => e is TeacherCalendarEvent && e.type == EventType.meeting)
          .length,
    };
  }
}
