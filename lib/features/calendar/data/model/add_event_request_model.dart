import 'package:equatable/equatable.dart';

class AddEventRequestModel extends Equatable {
  final String id;
  final String eventTitel;
  final String eventDesc;
  final String eventDate;
  final String eventTime;
  final String eventColor;

  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;

  const AddEventRequestModel({
    required this.id,
    required this.eventTitel,
    required this.eventDesc,
    required this.eventDate,
    required this.eventTime,
    required this.eventColor,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "eventtitel": eventTitel,
      "eventDesc": eventDesc,
      "eventdate": eventDate,
      "eventtime": eventTime,
      "eventcolore": eventColor,
      "SectionCode": sectionCode,
      "StageCode": stageCode,
      "LevelCode": levelCode,
      "ClassCode": classCode,
    };
  }

  factory AddEventRequestModel.fromJson(Map<String, dynamic> json) {
    return AddEventRequestModel(
      id: json["id"] ?? "",
      eventTitel: json["eventtitel"] ?? "",
      eventDesc: json["eventDesc"] ?? "",
      eventDate: json["eventdate"] ?? "",
      eventTime: json["eventtime"] ?? "",
      eventColor: json["eventcolore"] ?? "",
      sectionCode: json["SectionCode"] ?? 0,
      stageCode: json["StageCode"] ?? 0,
      levelCode: json["LevelCode"] ?? 0,
      classCode: json["ClassCode"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    eventTitel,
    eventDesc,
    eventDate,
    eventTime,
    eventColor,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
  ];
}
