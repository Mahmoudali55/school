import 'package:flutter/material.dart';
import 'package:my_template/features/bus/presentation/screen/admin_bus_tracking_screen.dart';
import 'package:my_template/features/bus/presentation/screen/bus_screen.dart';
import 'package:my_template/features/bus/presentation/screen/parent_bus_Screen.dart';
import 'package:my_template/features/bus/presentation/screen/teacher_bus_tracking_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_admin_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_patant_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_teacher_screen.dart';
import 'package:my_template/features/class/presentation/screen/admin_classes_screen.dart';
import 'package:my_template/features/class/presentation/screen/parent_classes_screen.dart';
import 'package:my_template/features/class/presentation/screen/student_classes_screen.dart';
import 'package:my_template/features/class/presentation/screen/teacher_classes_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/admin_home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/parent_home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/teacher_home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/ai_lesson_assistant_screen.dart';
import 'package:my_template/features/setting/presentation/screen/admin_settings_screen.dart';
import 'package:my_template/features/setting/presentation/screen/student_settings_screen.dart';

Widget getScreen(String tab, String userTypeId) {
  // Normalize user type with standard identifiers
  final cleanType = userTypeId.trim();
  String role;

  if (cleanType == '1' || cleanType == 'student') {
    role = 'student';
  } else if (cleanType == '2' || cleanType == 'parent') {
    role = 'parent';
  } else if (cleanType == '3' || cleanType == 'teacher') {
    role = 'teacher';
  } else {
    role = 'admin';
  }

  switch (tab) {
    case "home":
      if (role == 'parent') return const HomeParentScreen();
      if (role == 'teacher') return const TeacherHomeScreen();
      if (role == 'admin') return const AdminHomeScreen();
      return const HomeScreen();

    case "calendar":
      if (role == 'parent') return const CalendarPatentScreen();
      if (role == 'teacher') return const CalendarTeacherScreen();
      if (role == 'admin') return const AdminCalendarScreen();
      return const CalendarScreen();

    case "classes":
      if (role == 'parent') return const ParentClassScreen();
      if (role == 'teacher') return const TeacherClassesScreen();
      if (role == 'admin') return const AdminClassesScreen();
      return const StudentClassesScreen();

    case "bus":
      if (role == 'parent') return const ParentBusTrackingScreen();
      if (role == 'teacher') return const AILessonAssistantScreen();
      if (role == 'admin') return const AdminBusTrackingScreen();
      if (role == 'student') return const StudentBusTrackingScreen();
      return const StudentBusTrackingScreen();

    case "settings":
      if (role == 'admin') return const AdminSettingsScreen();
      return const StudentSettingsScreen();

    default:
      return const HomeScreen();
  }
}
