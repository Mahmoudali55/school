import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/Bus/presentation/screen/bus_screen.dart';
import 'package:my_template/features/bus/presentation/screen/admin_bus_tracking_screen.dart';
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
import 'package:my_template/features/setting/presentation/screen/admin_settings_screen.dart';
import 'package:my_template/features/setting/presentation/screen/student_settings_screen.dart';

Widget getScreen(String tab, String selectedUserType) {
  final role = selectedUserType;

  // استخدام المفاتيح المترجمة بدل النصوص الثابتة
  final parentRole = AppLocalKay.parent.tr();
  final teacherRole = AppLocalKay.teacher.tr();
  final adminRole = AppLocalKay.admin.tr();

  switch (tab) {
    case "home":
      return role == parentRole
          ? const HomeParentScreen()
          : role == teacherRole
          ? const TeacherHomeScreen()
          : role == adminRole
          ? const AdminHomeScreen()
          : const HomeScreen();
    case "calendar":
      return role == parentRole
          ? const CalendarPatentScreen()
          : role == teacherRole
          ? const CalendarTeacherScreen()
          : role == adminRole
          ? const AdminCalendarScreen()
          : const CalendarScreen();
    case "classes":
      return role == parentRole
          ? const ParentClassScreen()
          : role == teacherRole
          ? const TeacherClassesScreen()
          : role == adminRole
          ? const AdminClassesScreen()
          : const StudentClassesScreen();
    case "bus":
      return role == parentRole
          ? const ParentBusTrackingScreen()
          : role == teacherRole
          ? const TeacherBusTrackingScreen()
          : role == adminRole
          ? const AdminBusTrackingScreen()
          : const StudentBusTrackingScreen();
    case "settings":
      return role == parentRole
          ? const StudentSettingsScreen()
          : role == teacherRole
          ? const StudentSettingsScreen()
          : role == adminRole
          ? const AdminSettingsScreen()
          : const StudentSettingsScreen();
    default:
      return const HomeScreen();
  }
}
