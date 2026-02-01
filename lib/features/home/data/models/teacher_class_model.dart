import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherClassModels extends Equatable {
  final String deltaConfig;
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final String classNameAr;
  final int classCapacity;
  final int? floorCode;
  final int? teacherCode;
  final String? floorName;
  final String? teacherName;
  final int? newStudent;
  final int? oldStudent;
  final String? notes;

  const TeacherClassModels({
    required this.deltaConfig,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.classNameAr,
    required this.classCapacity,
    this.floorCode,
    this.teacherCode,
    this.floorName,
    this.teacherName,
    this.newStudent,
    this.oldStudent,
    this.notes,
  });

  factory TeacherClassModels.fromJson(Map<String, dynamic> json) {
    return TeacherClassModels(
      deltaConfig: json['DELTACONFIG']?.toString() ?? '',
      sectionCode: json['SECTION_CODE'] as int,
      stageCode: json['STAGE_CODE'] as int,
      levelCode: json['LEVEL_CODE'] as int,
      classCode: json['CLASS_CODE'] as int,
      classNameAr: json['CLASS_NAME_AR'] as String,
      classCapacity: json['CLASS_CAPACITY'] as int,
      floorCode: json['FLOOR_CODE'],
      teacherCode: json['TEACHER_CODE'],
      floorName: json['FloorName'],
      teacherName: json['TeacherName'],
      newStudent: json['newstudent'],
      oldStudent: json['oldstudent'],
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DELTACONFIG': deltaConfig,
      'SECTION_CODE': sectionCode,
      'STAGE_CODE': stageCode,
      'LEVEL_CODE': levelCode,
      'CLASS_CODE': classCode,
      'CLASS_NAME_AR': classNameAr,
      'CLASS_CAPACITY': classCapacity,
      'FLOOR_CODE': floorCode,
      'TEACHER_CODE': teacherCode,
      'FloorName': floorName,
      'TeacherName': teacherName,
      'newstudent': newStudent,
      'oldstudent': oldStudent,
      'NOTES': notes,
    };
  }

  /// 🔹 تحويل Response كامل من الـ API إلى List<Model>
  static List<TeacherClassModels> fromApiResponse(Map<String, dynamic> response) {
    final String dataString = response['Data'] as String;
    final List<dynamic> dataList = json.decode(dataString);

    return dataList.map((e) => TeacherClassModels.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [
    deltaConfig,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    classNameAr,
    classCapacity,
    floorCode,
    teacherCode,
    floorName,
    teacherName,
    newStudent,
    oldStudent,
    notes,
  ];
}
