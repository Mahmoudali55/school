import 'package:flutter/material.dart';

class ScheduleItem {
  final String time;
  final String subject;
  final String classroom;
  final String room;
  final bool isCurrent;

  ScheduleItem({
    required this.time,
    required this.subject,
    required this.classroom,
    required this.room,
    required this.isCurrent,
  });
}

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;

  QuickAction({required this.title, required this.icon, required this.color});
}

class Message {
  final String sender;
  final String preview;
  final String time;
  final bool unread;

  Message({required this.sender, required this.preview, required this.time, required this.unread});
}
