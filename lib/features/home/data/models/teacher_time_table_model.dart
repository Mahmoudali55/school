import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherTimeTableModel extends Equatable {
  final int id;
  final String day;
  final int period;
  final int subjectCode;
  final String subjectName;
  final int teacherCode;
  final String teacherName;
  final int classCode;
  final String startTime;
  final String endTime;
  final String room;

  const TeacherTimeTableModel({
    required this.id,
    required this.day,
    required this.period,
    required this.subjectCode,
    required this.subjectName,
    required this.teacherCode,
    required this.teacherName,
    required this.classCode,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory TeacherTimeTableModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimeTableModel(
      id: json['id'] ?? 0,
      day: json['day'] ?? '',
      period: json['period'] ?? 0,
      subjectCode: json['SubjectCode'] ?? 0,
      subjectName: json['SubjectName'] ?? '',
      teacherCode: json['TeacherCode'] ?? 0,
      teacherName: json['TeacherName'] ?? '',
      classCode: json['ClassCode'] ?? 0,
      startTime: json['StartTime'] ?? '',
      endTime: json['EndTime'] ?? '',
      room: json['room'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'SubjectCode': subjectCode,
      'SubjectName': subjectName,
      'TeacherCode': teacherCode,
      'TeacherName': teacherName,
      'ClassCode': classCode,
      'StartTime': startTime,
      'EndTime': endTime,
      'room': room,
    };
  }

  /// Helper لتحويل الـ Data String إلى List<Model>
  static List<TeacherTimeTableModel> listFromResponse(String data) {
    if (data.isEmpty || data == "[]") return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map((e) => TeacherTimeTableModel.fromJson(e)).toList();
  }

  /// 🔹 تحويل Response كامل من الـ API إلى List<Model>
  static List<TeacherTimeTableModel> fromApiResponse(Map<String, dynamic> response) {
    final String dataString = response['Data'] as String? ?? "";
    return listFromResponse(dataString);
  }

  @override
  List<Object?> get props => [
    id,
    day,
    period,
    subjectCode,
    subjectName,
    teacherCode,
    teacherName,
    classCode,
    startTime,
    endTime,
    room,
  ];
}
