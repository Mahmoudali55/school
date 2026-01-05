import 'package:flutter/material.dart';

import '../model/calendar_event_model.dart';

class CalendarRepo {
  final List<ClassInfo> _dummyClasses = [
    ClassInfo(id: '1', name: 'الصف العاشر', grade: 'العاشر', specialization: 'علمي'),
    ClassInfo(id: '2', name: 'الصف التاسع', grade: 'التاسع', specialization: 'أدبي'),
    ClassInfo(id: '3', name: 'الصف الحادي عشر', grade: 'الحادي عشر', specialization: 'علمي'),
  ];

  final List<TeacherCalendarEvent> _teacherEvents = [
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
  ];

  Future<List<ClassInfo>> getClasses(String userTypeId) async {
    return _dummyClasses;
  }

  Future<List<TeacherCalendarEvent>> getEvents(String userTypeId) async {
    // Return role-specific events here if needed
    return _teacherEvents;
  }
}
