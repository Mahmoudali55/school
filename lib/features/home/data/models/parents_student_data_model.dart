import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'home_models.dart'; // حيث StudentMiniInfo

class ParentsStudentData extends Equatable {
  final int studentCode;
  final String studentName;
  final int classCode;

  const ParentsStudentData({
    required this.studentCode,
    required this.studentName,
    required this.classCode,
  });

  factory ParentsStudentData.fromJson(Map<String, dynamic> json) {
    return ParentsStudentData(
      studentCode: json['STUDENT_CODE'] as int,
      studentName: json['S_NAME'] as String,
      classCode: json['ClassCode'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'STUDENT_CODE': studentCode, 'S_NAME': studentName, 'ClassCode': classCode};
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
  List<Object?> get props => [studentCode, studentName, classCode];
}
