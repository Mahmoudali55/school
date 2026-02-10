import 'dart:convert';

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int id;
  final String eventTitel;
  final String eventDesc;
  final String eventDate;
  final String eventTime;
  final String eventColore;

  const Event({
    required this.id,
    required this.eventTitel,
    required this.eventDesc,
    required this.eventDate,
    required this.eventTime,
    required this.eventColore,
  });

  // لتحويل JSON إلى كائن Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      eventTitel: json['event_titel'] as String,
      eventDesc: json['event_Desc'] as String,
      eventDate: json['event_date'] as String,
      eventTime: json['event_time'] as String,
      eventColore: json['event_colore'] as String,
    );
  }

  // لتحويل كائن Event إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_titel': eventTitel,
      'event_Desc': eventDesc,
      'event_date': eventDate,
      'event_time': eventTime,
      'event_colore': eventColore,
    };
  }

  @override
  List<Object?> get props => [id, eventTitel, eventDesc, eventDate, eventTime, eventColore];
}

class GetEventsResponse extends Equatable {
  final List<Event> events;

  const GetEventsResponse({required this.events});

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) {
    final dataString = json['Data'] as String;
    final List<dynamic> dataList = jsonDecode(dataString);
    final events = dataList.map((e) => Event.fromJson(e)).toList();
    return GetEventsResponse(events: events);
  }

  Map<String, dynamic> toJson() {
    return {'Data': jsonEncode(events.map((e) => e.toJson()).toList())};
  }

  @override
  List<Object?> get props => [events];
}
