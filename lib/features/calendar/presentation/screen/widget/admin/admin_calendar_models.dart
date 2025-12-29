import 'package:flutter/material.dart';

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
  });
}
