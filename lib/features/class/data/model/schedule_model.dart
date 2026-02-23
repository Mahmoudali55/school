import 'dart:convert';
import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final String day;
  final int period;
  final String subjectName;
  final int subjectCode;
  final String teacherName;
  final int teacherCode;
  final int classCode;
  final String startTime;
  final String endTime;
  final String? room;

  const ScheduleModel({
    required this.day,
    required this.period,
    required this.subjectName,
    required this.subjectCode,
    required this.teacherName,
    required this.teacherCode,
    required this.classCode,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      day: json['day'] ?? '',
      period: json['period'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      subjectCode: json['subjectCode'] ?? 0,
      teacherName: json['teacherName'] ?? '',
      teacherCode: json['teacherCode'] ?? 0,
      classCode: json['classCode'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'period': period,
      'subjectName': subjectName,
      'subjectCode': subjectCode,
      'teacherName': teacherName,
      'teacherCode': teacherCode,
      'classCode': classCode,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
    };
  }

  static List<ScheduleModel> fromList(List<dynamic> list) {
    return list.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [
    day,
    period,
    subjectName,
    subjectCode,
    teacherName,
    teacherCode,
    classCode,
    startTime,
    endTime,
    room,
  ];
}
