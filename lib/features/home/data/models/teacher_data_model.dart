import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherDataModel extends Equatable {
  final int teacherCode;
  final String teacherNameAr;
  final int COURSE_CODE;
  final int? sectionCode;
  final int? stageCode;

  const TeacherDataModel({
    required this.teacherCode,
    required this.teacherNameAr,
    required this.COURSE_CODE,
    this.sectionCode,
    this.stageCode,
  });

  factory TeacherDataModel.fromMap(Map<String, dynamic> map) {
    return TeacherDataModel(
      teacherCode: map['TEACHER_CODE'] ?? 0,
      teacherNameAr: map['TEACHER_NAME_AR'] ?? '',
      COURSE_CODE: map['COURSE_CODE'] ?? 0,
      sectionCode: map['SECTION_CODE'] ?? 0,
      stageCode: map['STAGE_CODE'] ?? 0,
    );
  }

  /// 🔥 دي المهمة عشان تتوافق مع الريبو بتاعك
  static List<TeacherDataModel> listFromResponse(dynamic response) {
    final dataString = response['Data'] ?? '[]';

    final List<dynamic> decodedList = jsonDecode(dataString);

    return decodedList.map((e) => TeacherDataModel.fromMap(e)).toList();
  }

  @override
  List<Object?> get props => [teacherCode, teacherNameAr];
}
