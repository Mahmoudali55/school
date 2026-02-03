import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassAbsentModel extends Equatable {
  final int levelCode;
  final int classCode;
  final int studentCode;
  final String notes;
  final int absentType;
  final String studentFullName;
  final String? absentDate;
  final String? classCodes;
  final int? stageCode;
  final int? sectionCode;

  const ClassAbsentModel({
    required this.levelCode,
    required this.classCode,
    required this.studentCode,
    required this.notes,
    required this.absentType,
    required this.studentFullName,
    this.absentDate,
    this.classCodes,
    this.stageCode,
    this.sectionCode,
  });

  factory ClassAbsentModel.fromJson(Map<String, dynamic> json) {
    return ClassAbsentModel(
      levelCode: json['LEVEL_CODE'] as int? ?? 0,
      classCode: json['CLASS_CODE'] as int? ?? 0,
      studentCode: json['STUDENT_CODE'] as int? ?? 0,
      notes: json['NOTES'] ?? '',
      absentType: json['ABSENT_TYPE'] as int? ?? 0,
      studentFullName: json['StudentfullName'] ?? '',
      absentDate: json['ABSENTDATE']?.toString(),
      classCodes: json['classcodes']?.toString(),
      stageCode: json['STAGECODE'] as int?,
      sectionCode: json['SECTIONCODE'] as int?,
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
      "ABSENTDATE": absentDate,
      "classcodes": classCodes,
      "STAGECODE": stageCode,
      "SECTIONCODE": sectionCode,
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
    absentDate,
    classCodes,
    stageCode,
    sectionCode,
  ];
}
