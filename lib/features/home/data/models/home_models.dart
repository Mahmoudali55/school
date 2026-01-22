import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeModel extends Equatable {
  final String userName;
  final String userRole;
  final List<HomeQuickAction> quickActions;
  final List<HomeNotification>? notifications;
  final int points;
  final int level;
  final List<String> badges;

  HomeModel({
    required this.userName,
    required this.userRole,
    required this.quickActions,
    this.notifications,
    this.points = 0,
    this.level = 1,
    this.badges = const [],
  });

  @override
  List<Object?> get props => [
    userName,
    userRole,
    quickActions,
    notifications,
    points,
    level,
    badges,
  ];
}

class HomeQuickAction extends Equatable {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  HomeQuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  List<Object?> get props => [title, icon, color];
}

class HomeNotification extends Equatable {
  final String title;
  final String time;
  final String type;

  HomeNotification({required this.title, required this.time, required this.type});

  @override
  List<Object?> get props => [title, time, type];
}

// Student Specific
class StudentHomeModel extends HomeModel {
  final String classInfo;
  final NextClass? nextClass;
  final List<UpcomingTask>? tasks;

  StudentHomeModel({
    required super.userName,
    required super.userRole,
    required super.quickActions,
    super.notifications,
    super.points,
    super.level,
    super.badges,
    required this.classInfo,
    this.nextClass,
    this.tasks,
  });

  @override
  List<Object?> get props => [...super.props, classInfo, nextClass, tasks];
}

class NextClass extends Equatable {
  final String subject;
  final String time;
  final String room;
  final String teacher;

  NextClass({required this.subject, required this.time, required this.room, required this.teacher});

  @override
  List<Object?> get props => [subject, time, room, teacher];
}

class UpcomingTask extends Equatable {
  final String title;
  final String subject;
  final String dueDate;

  UpcomingTask({required this.title, required this.subject, required this.dueDate});

  @override
  List<Object?> get props => [title, subject, dueDate];
}

class StudentMiniInfo extends Equatable {
  final String name;
  final String grade;
  final String? school;

  StudentMiniInfo({required this.name, required this.grade, this.school});

  @override
  List<Object?> get props => [name, grade, school];
}

// Parent Specific
class ParentHomeModel extends HomeModel {
  final List<StudentMiniInfo> students;
  final StudentMiniInfo selectedStudent;

  ParentHomeModel({
    required super.userName,
    required super.userRole,
    required super.quickActions,
    super.notifications,
    super.points,
    super.level,
    super.badges,
    required this.students,
    required this.selectedStudent,
  });

  @override
  List<Object?> get props => [...super.props, students, selectedStudent];
}

// Teacher Specific
class TeacherHomeModel extends HomeModel {
  final List<String> subjects;
  final Map<String, String> stats;
  final List<ScheduleItem>? schedule;

  TeacherHomeModel({
    required super.userName,
    required super.userRole,
    required super.quickActions,
    super.notifications,
    super.points,
    super.level,
    super.badges,
    required this.subjects,
    required this.stats,
    this.schedule,
  });

  @override
  List<Object?> get props => [...super.props, subjects, stats, schedule];
}

class ScheduleItem extends Equatable {
  final String time;
  final String subject;
  final String className;

  ScheduleItem({required this.time, required this.subject, required this.className});

  @override
  List<Object?> get props => [time, subject, className];
}

// Admin Specific
class AdminHomeModel extends HomeModel {
  final Map<String, Map<String, dynamic>> metrics;
  final List<AdminAlert>? alerts;

  AdminHomeModel({
    required super.userName,
    required super.userRole,
    required super.quickActions,
    super.notifications,
    super.points,
    super.level,
    super.badges,
    required this.metrics,
    this.alerts,
  });

  @override
  List<Object?> get props => [...super.props, metrics, alerts];
}

class AdminAlert extends Equatable {
  final String title;
  final String time;
  final String severity;

  AdminAlert({required this.title, required this.time, required this.severity});

  @override
  List<Object?> get props => [title, time, severity];
}
