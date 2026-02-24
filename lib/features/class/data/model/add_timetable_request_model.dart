import 'package:equatable/equatable.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';

class AddTimetableBatchRequestModel extends Equatable {
  final int classCode;
  final List<AddTimetableRequestModel> timetable;

  const AddTimetableBatchRequestModel({required this.classCode, required this.timetable});

  factory AddTimetableBatchRequestModel.fromScheduleList(
    int classCode,
    List<ScheduleModel> schedule,
  ) {
    return AddTimetableBatchRequestModel(
      classCode: classCode,
      timetable: schedule
          .map(
            (e) => AddTimetableRequestModel.fromScheduleModel(
              model: e,
              classCode: classCode, // 👈 نمرر classCode من هنا
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"classCode": classCode, "School_Time_table": timetable.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [classCode, timetable];
}

class AddTimetableRequestModel extends Equatable {
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
    required this.eventTime,
    required this.teacherCode,
    required this.teacherName,
    required this.classCode,
    required this.startTime,
    required this.endTime,
    this.room = '',
  });

  factory AddTimetableRequestModel.fromScheduleModel({
    required ScheduleModel model,
    required int classCode,
  }) {
    return AddTimetableRequestModel(
      id: '',
      day: model.day,
      period: model.period,
      subjectCode: model.subjectCode,
      subjectName: model.subjectName,
      eventTime: model.startTime,
      teacherCode: model.teacherCode,
      teacherName: model.teacherName,
      classCode: classCode, // 👈 ثابت من الباتش
      startTime: model.startTime,
      endTime: model.endTime,
      room: model.room ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "day": day,
      "period": period,
      "SubjectCode": subjectCode,
      "SubjectName": subjectName,
      "eventtime": eventTime,
      "TeacherCode": teacherCode,
      "TeacherName": teacherName,
      "ClassCode": classCode,
      "StartTime": startTime,
      "EndTime": endTime,
      "room": room,
    };
  }

  @override
  List<Object?> get props => [
    id,
    day,
    period,
    subjectCode,
    subjectName,
    eventTime,
    teacherCode,
    teacherName,
    classCode,
    startTime,
    endTime,
    room,
  ];
}
