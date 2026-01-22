import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentAbsentData extends Equatable {
  final int levelCode;
  final int classCode;
  final int studentCode;
  final String? notes;
  final int absentType;
  final String absentDate;
  final String studentFullName;

  const StudentAbsentData({
    required this.levelCode,
    required this.classCode,
    required this.studentCode,
    this.notes,
    required this.absentType,
    required this.absentDate,
    required this.studentFullName,
  });

  factory StudentAbsentData.fromJson(Map<String, dynamic> json) {
    return StudentAbsentData(
      levelCode: json['LEVEL_CODE'] as int,
      classCode: json['CLASS_CODE'] as int,
      studentCode: json['STUDENT_CODE'] as int,
      notes: json['NOTES'] as String?,
      absentType: json['ABSENT_TYPE'] as int,
      absentDate: json['ABSENT_DATE'] as String,
      studentFullName: json['StudentfullName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LEVEL_CODE': levelCode,
      'CLASS_CODE': classCode,
      'STUDENT_CODE': studentCode,
      'NOTES': notes,
      'ABSENT_TYPE': absentType,
      'ABSENT_DATE': absentDate,
      'StudentfullName': studentFullName,
    };
  }

  static List<StudentAbsentData> listFromDataString(String data) {
    if (data.isEmpty || data == "[]") return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => StudentAbsentData.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [
    levelCode,
    classCode,
    studentCode,
    notes,
    absentType,
    absentDate,
    studentFullName,
  ];
}
