import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherCoursesModel extends Equatable {
  final int teacherCode;
  final int lineSerial;
  final int courseCode;
  final String courseName;
  final String? notes;

  const TeacherCoursesModel({
    required this.teacherCode,
    required this.lineSerial,
    required this.courseCode,
    required this.courseName,
    this.notes,
  });

  factory TeacherCoursesModel.fromJson(Map<String, dynamic> json) {
    return TeacherCoursesModel(
      teacherCode: json['TEACHER_CODE'] as int,
      lineSerial: json['LINE_SERIAL'] as int,
      courseCode: json['COURSE_CODE'] as int,
      courseName: json['COURSE_Name'] as String,
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TEACHER_CODE': teacherCode,
      'LINE_SERIAL': lineSerial,
      'COURSE_CODE': courseCode,
      'COURSE_Name': courseName,
      'NOTES': notes,
    };
  }

  /// 🔹 تحويل Response كامل من الـ API إلى List<Model>
  static List<TeacherCoursesModel> fromApiResponse(Map<String, dynamic> response) {
    final String dataString = response['Data'] as String;
    final List<dynamic> dataList = json.decode(dataString);

    return dataList.map((e) => TeacherCoursesModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [teacherCode, lineSerial, courseCode, courseName, notes];
}
