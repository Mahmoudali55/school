import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
    : super(
        CalendarState(
          selectedDate: DateTime.now(),
          currentView: CalendarView.monthly,
          classes: _dummyClasses,
          events: _dummyEvents,
          selectedClass: _dummyClasses.first,
        ),
      );

  static final List<ClassInfo> _dummyClasses = [
    ClassInfo(id: '1', name: 'الصف العاشر', grade: 'العاشر', specialization: 'علمي'),
    ClassInfo(id: '2', name: 'الصف التاسع', grade: 'التاسع', specialization: 'أدبي'),
    ClassInfo(id: '3', name: 'الصف الحادي عشر', grade: 'الحادي عشر', specialization: 'علمي'),
  ];

  static final List<TeacherCalendarEvent> _dummyEvents = [
    TeacherCalendarEvent(
      id: '1',
      title: 'حصّة الرياضيات',
      date: DateTime.now(),
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 8, minute: 45),
      type: EventType.classEvent,
      location: 'القاعة ١٠١',
      description: 'الوحدة الثالثة - الجبر',
      className: 'الصف العاشر - علمي',
      subject: 'الرياضيات',
    ),
    TeacherCalendarEvent(
      id: '2',
      title: 'اجتماع المدرسين',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      type: EventType.meeting,
      location: 'قاعة الاجتماعات',
      description: 'مناقشة الخطط الدراسية',
      className: 'جميع الصفوف',
      subject: 'اجتماع',
    ),
    TeacherCalendarEvent(
      id: '3',
      title: 'تصحيح أوراق الامتحان',
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 0),
      type: EventType.correction,
      location: 'غرفة المدرسين',
      description: 'تصحيح امتحان منتصف الفصل',
      className: 'الصف العاشر - علمي',
      subject: 'الرياضيات',
      status: 'متأخر',
    ),
    TeacherCalendarEvent(
      id: '4',
      title: 'تحضير درس العلوم',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 16, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      type: EventType.preparation,
      location: 'المنزل',
      description: 'تحضير تجربة التفاعلات الكيميائية',
      className: 'الصف التاسع - أدبي',
      subject: 'العلوم',
      status: 'مكتمل',
    ),
  ];

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
