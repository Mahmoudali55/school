import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final String languageCode;
  final bool generalNotifications;
  final bool assignmentAlerts;
  final bool deadlineReminders;
  final bool announcements;
  final bool emailNotifications;

  const SettingsModel({
    this.languageCode = 'ar',
    this.generalNotifications = true,
    this.assignmentAlerts = true,
    this.deadlineReminders = true,
    this.announcements = true,
    this.emailNotifications = false,
  });

  SettingsModel copyWith({
    String? languageCode,
    bool? generalNotifications,
    bool? assignmentAlerts,
    bool? deadlineReminders,
    bool? announcements,
    bool? emailNotifications,
  }) {
    return SettingsModel(
      languageCode: languageCode ?? this.languageCode,
      generalNotifications: generalNotifications ?? this.generalNotifications,
      assignmentAlerts: assignmentAlerts ?? this.assignmentAlerts,
      deadlineReminders: deadlineReminders ?? this.deadlineReminders,
      announcements: announcements ?? this.announcements,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }

  @override
  List<Object?> get props => [
    languageCode,
    generalNotifications,
    assignmentAlerts,
    deadlineReminders,
    announcements,
    emailNotifications,
  ];
}
