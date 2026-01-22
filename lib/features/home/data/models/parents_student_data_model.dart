import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'home_models.dart'; // حيث StudentMiniInfo

class ParentsStudentData extends Equatable {
  final int studentCode;
  final String studentName;

  const ParentsStudentData({required this.studentCode, required this.studentName});

  factory ParentsStudentData.fromJson(Map<String, dynamic> json) {
    return ParentsStudentData(
      studentCode: json['STUDENT_CODE'] as int,
      studentName: json['S_NAME'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'STUDENT_CODE': studentCode, 'S_NAME': studentName};
  }

  /// ⭐⭐⭐ الحل هنا
  StudentMiniInfo toMiniInfo() {
    return StudentMiniInfo(studentCode: studentCode, name: studentName, grade: '');
  }

  static List<ParentsStudentData> listFromDataString(String data) {
    final List decoded = jsonDecode(data);
    return decoded.map((e) => ParentsStudentData.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [studentCode, studentName];
}
