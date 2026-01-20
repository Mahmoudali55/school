import 'package:flutter/material.dart';

class HomeModel {
  final String userName;
  final String userRole;
  final List<HomeQuickAction> quickActions;
  final List<HomeNotification>? notifications;

  HomeModel({
    required this.userName,
    required this.userRole,
    required this.quickActions,
    this.notifications,
    this.points = 0,
    this.level = 1,
    this.badges = const [],
  });

  final int points;
  final int level;
  final List<String> badges;
}

class HomeQuickAction {
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
}

class HomeNotification {
  final String title;
  final String time;
  final String type;

  HomeNotification({required this.title, required this.time, required this.type});
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
}

class NextClass {
  final String subject;
  final String time;
  final String room;
  final String teacher;

  NextClass({required this.subject, required this.time, required this.room, required this.teacher});
}

class UpcomingTask {
  final String title;
  final String subject;
  final String dueDate;

  UpcomingTask({required this.title, required this.subject, required this.dueDate});
}

// Parent Specific
class ParentHomeModel extends HomeModel {
  final List<String> students;
  final String selectedStudent;

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
}

class ScheduleItem {
  final String time;
  final String subject;
  final String className;

  ScheduleItem({required this.time, required this.subject, required this.className});
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
}

class AdminAlert {
  final String title;
  final String time;
  final String severity;

  AdminAlert({required this.title, required this.time, required this.severity});
}
