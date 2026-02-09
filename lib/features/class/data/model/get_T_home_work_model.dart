import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetTHomeWorkModel extends Equatable {
  final List<THomeWorkItem> data;

  const GetTHomeWorkModel({required this.data});

  factory GetTHomeWorkModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['Data'] as String;
    final decoded = jsonDecode(rawData) as List;

    return GetTHomeWorkModel(
      data: decoded.map((e) => THomeWorkItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object> get props => [data];
}

class THomeWorkItem extends Equatable {
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final int courseCode;
  final String notes;
  final String hw;
  final String hwDate;
  final String courseName;
  final String hW_path;

  const THomeWorkItem({
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.courseCode,
    required this.notes,
    required this.hw,
    required this.hwDate,
    required this.courseName,
    required this.hW_path,
  });

  factory THomeWorkItem.fromJson(Map<String, dynamic> json) {
    return THomeWorkItem(
      sectionCode: int.tryParse(json['SECTION_CODE']?.toString() ?? '0') ?? 0,
      stageCode: int.tryParse(json['Stage_Code']?.toString() ?? '0') ?? 0,
      levelCode: int.tryParse(json['LEVEL_CODE']?.toString() ?? '0') ?? 0,
      classCode: int.tryParse(json['CLASS_CODE']?.toString() ?? '0') ?? 0,
      hW_path: json['HW_path']?.toString() ?? '',
      courseCode:
          int.tryParse(
            (json['COURSE_CODE'] ??
                        json['CourseCode'] ??
                        json['SubjectCode'] ??
                        json['SUBJECT_CODE'] ??
                        json['subject_code'] ??
                        json['Course_Code'] ??
                        json['course_code'])
                    ?.toString() ??
                '0',
          ) ??
          0,
      notes: json['NOTES']?.toString() ?? '',
      hw: json['HW']?.toString() ?? '',
      hwDate: json['HW_DATE']?.toString() ?? '',

      courseName:
          (json['COURSE_Name'] ??
                  json['COURSE_NAME'] ??
                  json['CourseName'] ??
                  json['Coursename'] ??
                  json['course_name'])
              ?.toString() ??
          '',
    );
  }

  @override
  List<Object> get props => [
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    courseCode,
    notes,
    hw,
    hwDate,
    courseName,
    hW_path,
  ];
}
