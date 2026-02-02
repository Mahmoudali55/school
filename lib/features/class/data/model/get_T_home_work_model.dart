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
  });

  factory THomeWorkItem.fromJson(Map<String, dynamic> json) {
    return THomeWorkItem(
      sectionCode: json['SECTION_CODE'],
      stageCode: json['Stage_Code'],
      levelCode: json['LEVEL_CODE'],
      classCode: json['CLASS_CODE'],
      courseCode: json['COURSE_CODE'],
      notes: json['NOTES'],
      hw: json['HW'],
      hwDate: json['HW_DATE'],
      courseName: json['COURSE_Name'],
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
  ];
}
