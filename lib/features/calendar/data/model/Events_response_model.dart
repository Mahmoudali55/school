import 'dart:convert';

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int id;
  final String eventTitel;
  final String eventDesc;
  final String eventDate;
  final String eventTime;
  final String eventColore;

  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;

  const Event({
    required this.id,
    required this.eventTitel,
    required this.eventDesc,
    required this.eventDate,
    required this.eventTime,
    required this.eventColore,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      eventTitel: json['event_titel'] ?? '',
      eventDesc: json['event_Desc'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      eventColore: json['event_colore'] ?? '',
      sectionCode: json['SectionCode'] ?? 0,
      stageCode: json['StageCode'] ?? 0,
      levelCode: json['LevelCode'] ?? 0,
      classCode: json['ClassCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_titel': eventTitel,
      'event_Desc': eventDesc,
      'event_date': eventDate,
      'event_time': eventTime,
      'event_colore': eventColore,
      'SectionCode': sectionCode,
      'StageCode': stageCode,
      'LevelCode': levelCode,
      'ClassCode': classCode,
    };
  }

  DateTime get date {
    try {
      final parts = eventDate.split('/');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
    return DateTime.now();
  }

  @override
  List<Object?> get props => [
    id,
    eventTitel,
    eventDesc,
    eventDate,
    eventTime,
    eventColore,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
  ];
}

class GetEventsResponse extends Equatable {
  final List<Event> events;

  const GetEventsResponse({required this.events});

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) {
    final dataString = json['Data'] ?? '[]';
    final List<dynamic> dataList = jsonDecode(dataString);
    final events = dataList.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();

    return GetEventsResponse(events: events);
  }

  Map<String, dynamic> toJson() {
    return {'Data': jsonEncode(events.map((e) => e.toJson()).toList())};
  }

  @override
  List<Object?> get props => [events];
}
