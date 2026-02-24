import 'package:flutter/material.dart';
import 'package:my_template/features/calendar/data/model/Events_response_model.dart' as school;

class AdminCalendarEvent {
  final String title;
  final String date;
  final String time;
  final String type;
  final Color color;
  final String location;
  final String description;
  final List<String> participants;
  final String priority;
  final school.Event? originalEvent;

  AdminCalendarEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.color,
    required this.location,
    required this.description,
    required this.participants,
    required this.priority,
    this.originalEvent,
  });
}
