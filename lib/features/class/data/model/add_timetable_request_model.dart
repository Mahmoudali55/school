import 'package:my_template/features/class/data/model/schedule_model.dart';

class AddTimetableRequestModel {
  final String id;
  final String day;
  final int period;
  final int subjectCode;
  final String subjectName;
  final String eventTime;
  final int teacherCode;
  final String teacherName;
  final int classCode;
  final String startTime;
  final String endTime;
  final String room;

  const AddTimetableRequestModel({
    this.id = '',
    required this.day,
    required this.period,
    required this.subjectCode,
    required this.subjectName,
    this.eventTime = '',
    required this.teacherCode,
    required this.teacherName,
    required this.classCode,
    required this.startTime,
    required this.endTime,
    this.room = '',
  });

  factory AddTimetableRequestModel.fromScheduleModel(ScheduleModel model) {
    return AddTimetableRequestModel(
      id: '',
      day: model.day,
      period: model.period,
      subjectCode: model.subjectCode,
      subjectName: model.subjectName,
      eventTime: model.startTime,
      teacherCode: model.teacherCode,
      teacherName: model.teacherName,
      classCode: model.classCode,
      startTime: model.startTime,
      endTime: model.endTime,
      room: model.room ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'SubjectCode': subjectCode,
      'SubjectName': subjectName,
      'eventtime': eventTime,
      'TeacherCode': teacherCode,
      'TeacherName': teacherName,
      'ClassCode': classCode,
      'StartTime': startTime,
      'EndTime': endTime,
      'room': room,
    };
  }
}
