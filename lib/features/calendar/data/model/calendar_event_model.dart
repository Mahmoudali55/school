import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum EventType { classEvent, exam, meeting, correction, preparation }

extension EventTypeExtension on EventType {
  String get name {
    switch (this) {
      case EventType.classEvent:
        return "حصّة";
      case EventType.exam:
        return "امتحان";
      case EventType.meeting:
        return "اجتماع";
      case EventType.correction:
        return "تصحيح";
      case EventType.preparation:
        return "تحضير";
    }
  }

  Color get color {
    switch (this) {
      case EventType.classEvent:
        return const Color(0xFFFF9800);
      case EventType.exam:
        return const Color(0xFFDC2626);
      case EventType.meeting:
        return const Color(0xFF10B981);
      case EventType.correction:
        return const Color(0xFF7C3AED);
      case EventType.preparation:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.classEvent:
        return Icons.school;
      case EventType.exam:
        return Icons.assignment;
      case EventType.meeting:
        return Icons.groups;
      case EventType.correction:
        return Icons.grading;
      case EventType.preparation:
        return Icons.menu_book;
    }
  }
}

enum CalendarView { monthly, weekly, daily }

class TeacherCalendarEvent extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final EventType type;
  final String location;
  final String description;
  final String className;
  final String subject;
  final String status;
  final DateTime? reminder;

  const TeacherCalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.location,
    required this.description,
    required this.className,
    required this.subject,
    this.status = "مخطط",
    this.reminder,
  });

  // ===== copyWith =====
  TeacherCalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    EventType? type,
    String? location,
    String? description,
    String? className,
    String? subject,
    String? status,
    DateTime? reminder,
  }) {
    return TeacherCalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      location: location ?? this.location,
      description: description ?? this.description,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      reminder: reminder ?? this.reminder,
    );
  }

  // ===== UI helpers =====
  Color get color => type.color;
  IconData get icon => type.icon;
  String get typeName => type.name;

  String get formattedTime => '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:${minute} $period';
  }

  Duration get duration {
    final start = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
    final end = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    return end.difference(start);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    startTime.hour,
    startTime.minute,
    endTime.hour,
    endTime.minute,
    type,
    location,
    description,
    className,
    subject,
    status,
    reminder,
  ];
}

class ClassInfo {
  final String id;
  final String name;
  final String grade;
  final String specialization;

  ClassInfo({
    required this.id,
    required this.name,
    required this.grade,
    required this.specialization,
  });

  String get fullName => '$grade - $specialization';
}
