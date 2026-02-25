import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final String id;
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
    this.id = '',
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
      id: (json['id'] ?? json['Id'])?.toString() ?? '',
      day: json['day'] ?? '',
      period: json['period'] ?? 0,
      subjectName: json['subjectName'] ?? json['SubjectName'] ?? '',
      subjectCode: json['subjectCode'] ?? json['SubjectCode'] ?? 0,
      teacherName: json['teacherName'] ?? json['TeacherName'] ?? '',
      teacherCode: json['teacherCode'] ?? json['TeacherCode'] ?? 0,
      classCode: json['classCode'] ?? json['ClassCode'] ?? 0,
      startTime: json['startTime'] ?? json['StartTime'] ?? '',
      endTime: json['endTime'] ?? json['EndTime'] ?? '',
      room: json['room'] ?? json['Room'],
    );
  }

  ScheduleModel copyWith({
    String? id,
    String? day,
    int? period,
    String? subjectName,
    int? subjectCode,
    String? teacherName,
    int? teacherCode,
    int? classCode,
    String? startTime,
    String? endTime,
    String? room,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      day: day ?? this.day,
      period: period ?? this.period,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      teacherName: teacherName ?? this.teacherName,
      teacherCode: teacherCode ?? this.teacherCode,
      classCode: classCode ?? this.classCode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    id,
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
