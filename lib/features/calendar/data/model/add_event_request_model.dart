import 'package:equatable/equatable.dart';

class AddEventRequestModel extends Equatable {
  final String id;
  final String eventTitel;
  final String eventDesc;
  final String eventDate;
  final String eventTime;
  final String eventColor;

  const AddEventRequestModel({
    required this.id,
    required this.eventTitel,
    required this.eventDesc,
    required this.eventDate,
    required this.eventTime,
    required this.eventColor,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "eventtitel": eventTitel,
      "eventDesc": eventDesc,
      "eventdate": eventDate,
      "eventtime": eventTime,
      "eventcolore": eventColor,
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
    );
  }

  @override
  List<Object?> get props => [id, eventTitel, eventDesc, eventDate, eventTime, eventColor];
}
