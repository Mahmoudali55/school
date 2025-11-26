import 'package:flutter/material.dart';

class Alert {
  final String title;
  final String description;
  final AlertType type;
  final String time;
  final bool isUrgent;

  Alert({
    required this.title,
    required this.description,
    required this.type,
    required this.time,
    required this.isUrgent,
  });
}

enum AlertType { technical, security }

class MetricCard {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class Activity {
  final String user;
  final String action;
  final String time;

  Activity({required this.user, required this.action, required this.time});
}

class ManagementShortcut {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final void Function(BuildContext context)? onTap;
  ManagementShortcut({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });
}
