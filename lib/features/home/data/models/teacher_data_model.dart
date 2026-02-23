import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherDataModel extends Equatable {
  final int teacherCode;
  final String teacherNameAr;
  final int COURSE_CODE;

  const TeacherDataModel({
    required this.teacherCode,
    required this.teacherNameAr,
    required this.COURSE_CODE,
  });

  factory TeacherDataModel.fromMap(Map<String, dynamic> map) {
    return TeacherDataModel(
      teacherCode: map['TEACHER_CODE'] ?? 0,
      teacherNameAr: map['TEACHER_NAME_AR'] ?? '',
      COURSE_CODE: map['COURSE_CODE'] ?? 0,
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
