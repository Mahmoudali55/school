import 'package:equatable/equatable.dart';

class StudentCoursesModel extends Equatable {
  final int levelCode;
  final int courseCode;
  final String courseNameAr;
  final String? notes;

  const StudentCoursesModel({
    required this.levelCode,
    required this.courseCode,
    required this.courseNameAr,
    this.notes,
  });

  factory StudentCoursesModel.fromJson(Map<String, dynamic> json) {
    return StudentCoursesModel(
      levelCode: json['LEVEL_CODE'] as int,
      courseCode: json['COURSE_CODE'] as int,
      courseNameAr: json['COURSE_NAME_AR'] as String,
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LEVEL_CODE': levelCode,
      'COURSE_CODE': courseCode,
      'COURSE_NAME_AR': courseNameAr,
      'NOTES': notes,
    };
  }

  @override
  List<Object?> get props => [levelCode, courseCode, courseNameAr, notes];
}
