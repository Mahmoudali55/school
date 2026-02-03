import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetStudentClassData extends Equatable {
  final List<StudentItem> students;

  const GetStudentClassData({required this.students});

  factory GetStudentClassData.fromJson(Map<String, dynamic> json) {
    final List decodedList = json['Data'] != null ? jsonDecode(json['Data']) as List : [];

    return GetStudentClassData(
      students: decodedList.map((e) => StudentItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => [students];
}

class StudentItem extends Equatable {
  final int studentCode;
  final String studentName;

  const StudentItem({required this.studentCode, required this.studentName});

  factory StudentItem.fromJson(Map<String, dynamic> json) {
    return StudentItem(
      studentCode: json['STUDENT_CODE'] as int,
      studentName: json['S_NAME'] as String,
    );
  }

  @override
  List<Object?> get props => [studentCode, studentName];
}
