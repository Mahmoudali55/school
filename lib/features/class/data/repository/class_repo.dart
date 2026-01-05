import 'package:flutter/material.dart';
import 'package:my_template/features/class/data/model/class_models.dart';

class ClassRepo {
  final List<StudentClassModel> _studentClasses = const [
    StudentClassModel(
      id: '1',
      className: 'الرياضيات',
      teacherName: 'أ. أحمد محمد',
      room: 'القاعة ١٠١',
      time: '٨:٠٠ ص - ٩:٣٠ ص',
      color: Colors.blue,
      icon: Icons.calculate,
    ),
    StudentClassModel(
      id: '2',
      className: 'اللغة العربية',
      teacherName: 'أ. فاطمة علي',
      room: 'القاعة ٢٠٣',
      time: '١٠:٠٠ ص - ١١:٣٠ ص',
      color: Colors.green,
      icon: Icons.menu_book,
    ),
    StudentClassModel(
      id: '3',
      className: 'العلوم',
      teacherName: 'أ. خالد إبراهيم',
      room: 'المعمل ٣٠١',
      time: '١٢:٠٠ م - ١:٣٠ م',
      color: Colors.orange,
      icon: Icons.science,
    ),
  ];

  final List<TeacherClassModel> _teacherClasses = const [
    TeacherClassModel(
      id: '1',
      className: 'الصف العاشر - الرياضيات',
      studentCount: 32,
      schedule: 'السبت، الإثنين، الأربعاء',
      time: '٨:٠٠ ص - ٩:٣٠ ص',
      room: 'القاعة ١٠١',
      progress: 0.75,
      assignments: 3,
    ),
    TeacherClassModel(
      id: '2',
      className: 'الصف التاسع - الرياضيات',
      studentCount: 28,
      schedule: 'الأحد، الثلاثاء، الخميس',
      time: '١٠:٠٠ ص - ١١:٣٠ ص',
      room: 'القاعة ٢٠٣',
      progress: 0.60,
      assignments: 2,
    ),
  ];

  final List<AdminClassModel> _adminClasses = const [
    AdminClassModel(
      id: '1',
      name: 'الصف الأول - أ',
      grade: 'الأول',
      section: 'أ',
      capacity: 30,
      currentStudents: 25,
      teacher: 'أحمد محمد',
      room: '101',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
    AdminClassModel(
      id: '2',
      name: 'الصف الأول - ب',
      grade: 'الأول',
      section: 'ب',
      capacity: 30,
      currentStudents: 28,
      teacher: 'فاطمة علي',
      room: '102',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
  ];

  Future<List<StudentClassModel>> getStudentClasses() async {
    return _studentClasses;
  }

  Future<List<TeacherClassModel>> getTeacherClasses() async {
    return _teacherClasses;
  }

  Future<List<AdminClassModel>> getAdminClasses() async {
    return _adminClasses;
  }

  Future<List<StudentClassModel>> getParentStudentClasses() async {
    return _studentClasses;
  }
}
