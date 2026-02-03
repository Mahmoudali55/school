import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassAbsentModel extends Equatable {
  final int levelCode;
  final int classCode;
  final int studentCode;
  final String notes;
  final int absentType;
  final String studentFullName;

  const ClassAbsentModel({
    required this.levelCode,
    required this.classCode,
    required this.studentCode,
    required this.notes,
    required this.absentType,
    required this.studentFullName,
  });

  factory ClassAbsentModel.fromJson(Map<String, dynamic> json) {
    return ClassAbsentModel(
      levelCode: json['LEVEL_CODE'] as int,
      classCode: json['CLASS_CODE'] as int,
      studentCode: json['STUDENT_CODE'] as int,
      notes: json['NOTES'] ?? '',
      absentType: json['ABSENT_TYPE'] as int,
      studentFullName: json['StudentfullName'] ?? '',
    );
  }

  static List<ClassAbsentModel> listFromJson(String source) {
    final List<dynamic> data = jsonDecode(source);
    return data.map((e) => ClassAbsentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "LEVEL_CODE": levelCode,
      "CLASS_CODE": classCode,
      "STUDENT_CODE": studentCode,
      "NOTES": notes,
      "ABSENT_TYPE": absentType,
      "StudentfullName": studentFullName,
    };
  }

  @override
  List<Object?> get props => [
    levelCode,
    classCode,
    studentCode,
    notes,
    absentType,
    studentFullName,
  ];
}
