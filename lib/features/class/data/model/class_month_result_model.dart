import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassMonthResultModel extends Equatable {
  final int? levelCode;
  final int? classCode;
  final int? monthNo;
  final String? notes;
  final int? courseCode;
  final String? className;
  final String? courseName;
  final double? courseDegree;
  final double? studentDegree;

  const ClassMonthResultModel({
    this.levelCode,
    this.classCode,
    this.monthNo,
    this.notes,
    this.courseCode,
    this.className,
    this.courseName,
    this.courseDegree,
    this.studentDegree,
  });

  factory ClassMonthResultModel.fromJson(Map<String, dynamic> json) {
    return ClassMonthResultModel(
      levelCode: json['LEVEL_CODE'],
      classCode: json['CLASS_CODE'],
      monthNo: json['MONTH_NO'],
      notes: json['NOTES'],
      courseCode: json['COURSE_CODE'],
      className: json['classname'],
      courseName: json['COURSE_Name'],
      courseDegree: (json['COURSE_DEGREE'] as num?)?.toDouble(),
      studentDegree: (json['STUDENT_DEGREE'] as num?)?.toDouble(),
    );
  }

  static List<ClassMonthResultModel> listFromResponse(Map<String, dynamic> response) {
    final dataString = response['Data'];

    if (dataString == null || dataString.isEmpty) return [];

    final List decoded = jsonDecode(dataString);

    return decoded.map((e) => ClassMonthResultModel.fromJson(e)).toList();
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
