import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentCourseDegree extends Equatable {
  final int levelCode;
  final int classCode;
  final int monthNo;
  final String? notes;
  final int courseCode;
  final String className;
  final String courseName;
  final double courseDegree;
  final double studentDegree;

  const StudentCourseDegree({
    required this.levelCode,
    required this.classCode,
    required this.monthNo,
    this.notes,
    required this.courseCode,
    required this.className,
    required this.courseName,
    required this.courseDegree,
    required this.studentDegree,
  });

  factory StudentCourseDegree.fromJson(Map<String, dynamic> json) {
    return StudentCourseDegree(
      levelCode: json['LEVEL_CODE'] as int,
      classCode: json['CLASS_CODE'] as int,
      monthNo: json['MONTH_NO'] as int,
      notes: json['NOTES'],
      courseCode: json['COURSE_CODE'] as int,
      className: json['classname'] as String,
      courseName: json['COURSE_Name'] as String,
      courseDegree: (json['COURSE_DEGREE'] as num).toDouble(),
      studentDegree: (json['STUDENT_DEGREE'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LEVEL_CODE': levelCode,
      'CLASS_CODE': classCode,
      'MONTH_NO': monthNo,
      'NOTES': notes,
      'COURSE_CODE': courseCode,
      'classname': className,
      'COURSE_Name': courseName,
      'COURSE_DEGREE': courseDegree,
      'STUDENT_DEGREE': studentDegree,
    };
  }

  /// لتحويل Data String إلى List<StudentCourseDegree>
  static List<StudentCourseDegree> listFromDataString(String data) {
    if (data.isEmpty || data == "[]") return [];
    final List decoded = jsonDecode(data); // decode JSON داخل String
    return decoded.map((e) => StudentCourseDegree.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [
    levelCode,
    classCode,
    monthNo,
    notes,
    courseCode,
    className,
    courseName,
    courseDegree,
    studentDegree,
  ];
}
