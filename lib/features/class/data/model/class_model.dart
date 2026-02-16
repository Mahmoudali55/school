import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetClassModel extends Equatable {
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

  const GetClassModel({
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

  /// من JSON Map لكائن ClassModel
  factory GetClassModel.fromJson(Map<String, dynamic> json) {
    return GetClassModel(
      deltaConfig: json['DELTACONFIG'] ?? '',
      sectionCode: json['SECTION_CODE'] ?? 0,
      stageCode: json['STAGE_CODE'] ?? 0,
      levelCode: json['LEVEL_CODE'] ?? 0,
      classCode: json['CLASS_CODE'] ?? 0,
      classNameAr: json['CLASS_NAME_AR'] ?? '',
      classCapacity: json['CLASS_CAPACITY'] ?? 0,
      floorCode: json['FLOOR_CODE'],
      teacherCode: json['TEACHER_CODE'],
      floorName: json['FloorName'],
      teacherName: json['TeacherName'],
      newStudent: json['newstudent'],
      oldStudent: json['oldstudent'],
      notes: json['NOTES'],
    );
  }

  /// تحويل الكائن إلى JSON Map
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

  /// لتحويل JSON string كامل لقائمة من الكائنات
  static List<GetClassModel> listFromJson(String jsonString) {
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.map((e) => GetClassModel.fromJson(e)).toList();
    } else if (decoded is Map<String, dynamic>) {
      final data = decoded['Data'];
      if (data is String) {
        final List<dynamic> dataList = json.decode(data);
        return dataList.map((e) => GetClassModel.fromJson(e)).toList();
      } else if (data is List) {
        return data.map((e) => GetClassModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  /// Equatable props
  @override
  List<Object?> get props => [classCode];
}
