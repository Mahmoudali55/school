import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

import 'teacher_classes_state.dart';

class TeacherClassesCubit extends Cubit<TeacherClassesState> {
  TeacherClassesCubit()
    : super(
        TeacherClassesState(
          teacherInfo: TeacherInfo(
            name: 'أ. أحمد محمد',
            subject: 'مدرس الرياضيات',
            email: 'ahmed@school.edu',
          ),
          classes: _dummyClasses,
          stats: _calculateStats(_dummyClasses),
        ),
      );

  static final List<ClassInfo> _dummyClasses = [
    ClassInfo(
      id: '1',
      className: 'الصف العاشر - الرياضيات',
      studentCount: 32,
      schedule: 'السبت، الإثنين، الأربعاء',
      time: '٨:٠٠ ص - ٩:٣٠ ص',
      room: 'القاعة ١٠١',
      progress: 0.75,
      assignments: 3,
    ),
    ClassInfo(
      id: '2',
      className: 'الصف التاسع - الرياضيات',
      studentCount: 28,
      schedule: 'الأحد، الثلاثاء، الخميس',
      time: '١٠:٠٠ ص - ١١:٣٠ ص',
      room: 'القاعة ٢٠٣',
      progress: 0.60,
      assignments: 2,
    ),
    ClassInfo(
      id: '3',
      className: 'الصف الحادي عشر - الرياضيات',
      studentCount: 25,
      schedule: 'السبت، الإثنين، الأربعاء',
      time: '١٢:٠٠ م - ١:٣٠ م',
      room: 'القاعة ٣٠١',
      progress: 0.85,
      assignments: 4,
    ),
  ];

  static ClassStats _calculateStats(List<ClassInfo> classes) {
    final totalStudents = classes.fold(0, (sum, classInfo) => sum + classInfo.studentCount);
    final totalAssignments = classes.fold(0, (sum, classInfo) => sum + classInfo.assignments);
    return ClassStats(
      totalStudents: totalStudents,
      totalAssignments: totalAssignments,
      attendanceRate: 0.92,
    );
  }

  void updateTeacherInfo(TeacherInfo newInfo) {
    emit(state.copyWith(teacherInfo: newInfo));
  }

  void addClass(ClassInfo newClass) {
    final updatedClasses = List<ClassInfo>.from(state.classes)..add(newClass);
    final updatedStats = _calculateStats(updatedClasses);
    emit(state.copyWith(classes: updatedClasses, stats: updatedStats));
  }

  void deleteClass(String classId) {
    final updatedClasses = state.classes.where((c) => c.id != classId).toList();
    final updatedStats = _calculateStats(updatedClasses);
    emit(state.copyWith(classes: updatedClasses, stats: updatedStats));
  }

  void updateClass(String classId, ClassInfo updatedClass) {
    final updatedClasses = state.classes.map((c) => c.id == classId ? updatedClass : c).toList();
    final updatedStats = _calculateStats(updatedClasses);
    emit(state.copyWith(classes: updatedClasses, stats: updatedStats));
  }

  void filterClasses(String filter) {
    emit(state.copyWith(filterType: filter));
  }

  void clearFilter() {
    emit(state.copyWith(filterType: null));
  }

  void updateProgress(String classId, double newProgress) {
    final updatedClasses = state.classes.map((classInfo) {
      if (classInfo.id == classId) {
        return classInfo.copyWith(progress: newProgress);
      }
      return classInfo;
    }).toList();
    emit(state.copyWith(classes: updatedClasses));
  }

  void addAssignment(String classId) {
    final updatedClasses = state.classes.map((classInfo) {
      if (classInfo.id == classId) {
        return classInfo.copyWith(assignments: classInfo.assignments + 1);
      }
      return classInfo;
    }).toList();
    final updatedStats = _calculateStats(updatedClasses);
    emit(state.copyWith(classes: updatedClasses, stats: updatedStats));
  }
}
