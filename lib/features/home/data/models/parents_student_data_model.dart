import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'home_models.dart';

class ParentsStudentData extends Equatable {
  final int studentCode;
  final String studentName;
  final int classCode;
  final int levelCode;
  final int stageCode;
  final int sectionCode;

  const ParentsStudentData({
    required this.studentCode,
    required this.studentName,
    required this.classCode,
    required this.levelCode,
    required this.stageCode,
    required this.sectionCode,
  });

  factory ParentsStudentData.fromJson(Map<String, dynamic> json) {
    return ParentsStudentData(
      studentCode: json['STUDENT_CODE'] ?? 0,
      studentName: json['S_NAME'] ?? '',
      classCode: json['CLASS_CODE'] ?? 0,
      levelCode: json['LEVEL_CODE'] ?? 0,
      stageCode: json['STAGE_CODE'] ?? 0,
      sectionCode: json['SECTION_CODE'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STUDENT_CODE': studentCode,
      'S_NAME': studentName,
      'CLASS_CODE': classCode,
      'LEVEL_CODE': levelCode,
      'STAGE_CODE': stageCode,
      'SECTION_CODE': sectionCode,
    };
  }

  /// تحويل إلى Mini Info
  StudentMiniInfo toMiniInfo() {
    return StudentMiniInfo(
      studentCode: studentCode,
      name: studentName,
      grade: levelCode.toString(), // أو حسب منطقك
    );
  }

  /// لتحويل Data (String) القادمة من الـ API
  static List<ParentsStudentData> listFromResponse(Map<String, dynamic> json) {
    final dataString = json['Data'] ?? '[]';
    final List decoded = jsonDecode(dataString);
    return decoded.map((e) => ParentsStudentData.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [
    studentCode,
    studentName,
    classCode,
    levelCode,
    stageCode,
    sectionCode,
  ];
}
