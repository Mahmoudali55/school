import 'package:equatable/equatable.dart';

import '../../data/model/teacher_classes_models.dart';

class TeacherClassesState extends Equatable {
  final TeacherInfo teacherInfo;
  final List<ClassInfo> classes;
  final ClassStats stats;
  final bool isLoading;
  final String? error;
  final String? filterType;

  const TeacherClassesState({
    required this.teacherInfo,
    required this.classes,
    required this.stats,
    this.isLoading = false,
    this.error,
    this.filterType,
  });

  TeacherClassesState copyWith({
    TeacherInfo? teacherInfo,
    List<ClassInfo>? classes,
    ClassStats? stats,
    bool? isLoading,
    String? error,
    String? filterType,
  }) {
    return TeacherClassesState(
      teacherInfo: teacherInfo ?? this.teacherInfo,
      classes: classes ?? this.classes,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterType: filterType ?? this.filterType,
    );
  }

  List<ClassInfo> get filteredClasses {
    if (filterType == null || filterType!.isEmpty) {
      return classes;
    }
    return classes.where((classInfo) => classInfo.className.contains(filterType!)).toList();
  }

  @override
  List<Object?> get props => [teacherInfo, classes, stats, isLoading, error, filterType];
}
