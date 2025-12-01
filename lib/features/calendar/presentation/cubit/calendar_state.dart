import 'package:equatable/equatable.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final CalendarView currentView;
  final ClassInfo? selectedClass;
  final List<ClassInfo> classes;
  final List<TeacherCalendarEvent> events;
  final bool isLoading;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    required this.currentView,
    this.selectedClass,
    required this.classes,
    required this.events,
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    CalendarView? currentView,
    ClassInfo? selectedClass,
    List<ClassInfo>? classes,
    List<TeacherCalendarEvent>? events,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentView: currentView ?? this.currentView,
      selectedClass: selectedClass ?? this.selectedClass,
      classes: classes ?? this.classes,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<TeacherCalendarEvent> getEventsForDay(DateTime day) {
    return events
        .where(
          (event) =>
              event.date.year == day.year &&
              event.date.month == day.month &&
              event.date.day == day.day,
        )
        .toList();
  }

  List<TeacherCalendarEvent> getEventsForWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return events
        .where(
          (event) =>
              event.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              event.date.isBefore(endOfWeek.add(const Duration(days: 1))),
        )
        .toList();
  }

  List<TeacherCalendarEvent> getEventsForMonth(DateTime month) {
    return events
        .where((event) => event.date.year == month.year && event.date.month == month.month)
        .toList();
  }

  List<TeacherCalendarEvent> getDailyClasses(DateTime day) {
    return getEventsForDay(day).where((event) => event.type == EventType.classEvent).toList();
  }

  List<TeacherCalendarEvent> getDailyTasks(DateTime day) {
    return getEventsForDay(day)
        .where((event) => event.type == EventType.correction || event.type == EventType.preparation)
        .toList();
  }

  Map<String, dynamic> getMonthlyStats(DateTime month) {
    final monthEvents = getEventsForMonth(month);
    return {
      'classes': monthEvents.where((e) => e.type == EventType.classEvent).length,
      'exams': monthEvents.where((e) => e.type == EventType.exam).length,
      'meetings': monthEvents.where((e) => e.type == EventType.meeting).length,
    };
  }

  @override
  List<Object?> get props => [
    selectedDate,
    currentView,
    selectedClass,
    classes,
    events,
    isLoading,
    error,
  ];
}
