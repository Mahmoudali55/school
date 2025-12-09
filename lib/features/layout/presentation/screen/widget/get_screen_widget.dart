import 'package:flutter/material.dart';
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

Widget getScreen(String tab, String userTypeId) {
  // استخدام المعرفات الثابتة بدلاً من النصوص المترجمة
  const parentId = 'parent';
  const teacherId = 'teacher';
  const adminId = 'admin';

  switch (tab) {
    case "home":
      return userTypeId == parentId
          ? const HomeParentScreen()
          : userTypeId == teacherId
          ? const TeacherHomeScreen()
          : userTypeId == adminId
          ? const AdminHomeScreen()
          : const HomeScreen();
    case "calendar":
      return userTypeId == parentId
          ? const CalendarPatentScreen()
          : userTypeId == teacherId
          ? const CalendarTeacherScreen()
          : userTypeId == adminId
          ? const AdminCalendarScreen()
          : const CalendarScreen();
    case "classes":
      return userTypeId == parentId
          ? const ParentClassScreen()
          : userTypeId == teacherId
          ? const TeacherClassesScreen()
          : userTypeId == adminId
          ? const AdminClassesScreen()
          : const StudentClassesScreen();
    case "bus":
      return userTypeId == parentId
          ? const ParentBusTrackingScreen()
          : userTypeId == teacherId
          ? const TeacherBusTrackingScreen()
          : userTypeId == adminId
          ? const AdminBusTrackingScreen()
          : const StudentBusTrackingScreen();
    case "settings":
      return userTypeId == parentId
          ? const StudentSettingsScreen()
          : userTypeId == teacherId
          ? const StudentSettingsScreen()
          : userTypeId == adminId
          ? const AdminSettingsScreen()
          : const StudentSettingsScreen();
    default:
      return const HomeScreen();
  }
}
