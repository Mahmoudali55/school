import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/data/repo/calendar_repo.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepo _calendarRepo;

  CalendarCubit(this._calendarRepo)
    : super(
        CalendarState(
          selectedDate: DateTime.now(),
          currentView: CalendarView.monthly,
          classes: const [],
          events: const [],
        ),
      );

  Future<void> getCalendarData(String userTypeId) async {
    if (state.classes.isEmpty && state.events.isEmpty) {
      emit(state.copyWith(isLoading: true));
    }
    try {
      final classes = await _calendarRepo.getClasses(userTypeId);
      final events = await _calendarRepo.getEvents(userTypeId);
      emit(
        state.copyWith(
          classes: classes,
          events: events,
          selectedClass: state.selectedClass ?? (classes.isNotEmpty ? classes.first : null),
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void changeView(CalendarView view) {
    emit(state.copyWith(currentView: view));
  }

  void changeClass(ClassInfo? selectedClass) {
    emit(state.copyWith(selectedClass: selectedClass));
  }

  void goToPrevious() {
    DateTime newDate;
    switch (state.currentView) {
      case CalendarView.monthly:
        newDate = DateTime(state.selectedDate.year, state.selectedDate.month - 1);
        break;
      case CalendarView.weekly:
        newDate = state.selectedDate.subtract(const Duration(days: 7));
        break;
      case CalendarView.daily:
        newDate = state.selectedDate.subtract(const Duration(days: 1));
        break;
    }
    emit(state.copyWith(selectedDate: newDate));
  }

  void goToNext() {
    DateTime newDate;
    switch (state.currentView) {
      case CalendarView.monthly:
        newDate = DateTime(state.selectedDate.year, state.selectedDate.month + 1);
        break;
      case CalendarView.weekly:
        newDate = state.selectedDate.add(const Duration(days: 7));
        break;
      case CalendarView.daily:
        newDate = state.selectedDate.add(const Duration(days: 1));
        break;
    }
    emit(state.copyWith(selectedDate: newDate));
  }

  void addEvent(TeacherCalendarEvent event) {
    final newEvents = List<TeacherCalendarEvent>.from(state.events)..add(event);
    emit(state.copyWith(events: newEvents));
  }

  void updateEvent(TeacherCalendarEvent event) {
    final newEvents = state.events.map((e) => e.id == event.id ? event : e).toList();
    emit(state.copyWith(events: newEvents));
  }

  void deleteEvent(String eventId) {
    final newEvents = state.events.where((e) => e.id != eventId).toList();
    emit(state.copyWith(events: newEvents));
  }

  void toggleTaskStatus(String eventId) {
    final newEvents = state.events.map((event) {
      if (event.id == eventId) {
        final newStatus = event.status == "مكتمل" ? "مخطط" : "مكتمل";
        return TeacherCalendarEvent(
          id: event.id,
          title: event.title,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          type: event.type,
          location: event.location,
          description: event.description,
          className: event.className,
          subject: event.subject,
          status: newStatus,
        );
      }
      return event;
    }).toList();
    emit(state.copyWith(events: newEvents));
  }
}
