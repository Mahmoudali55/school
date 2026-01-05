import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final bool isUrgent;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String category;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.isUrgent,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.category,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    bool? isRead,
    bool? isUrgent,
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    String? category,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      isUrgent: isUrgent ?? this.isUrgent,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      category: category ?? this.category,
    );
  }
}
