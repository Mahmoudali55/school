import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final String languageCode;
  final bool generalNotifications;
  final bool assignmentAlerts;
  final bool deadlineReminders;
  final bool announcements;
  final bool emailNotifications;
  // Privacy
  final bool showProfile;
  final bool showEmail;
  final bool showPhone;
  final bool allowSearch;

  const SettingsModel({
    this.languageCode = 'ar',
    this.generalNotifications = true,
    this.assignmentAlerts = true,
    this.deadlineReminders = true,
    this.announcements = true,
    this.emailNotifications = false,
    this.showProfile = true,
    this.showEmail = false,
    this.showPhone = false,
    this.allowSearch = true,
  });

  SettingsModel copyWith({
    String? languageCode,
    bool? generalNotifications,
    bool? assignmentAlerts,
    bool? deadlineReminders,
    bool? announcements,
    bool? emailNotifications,
    bool? showProfile,
    bool? showEmail,
    bool? showPhone,
    bool? allowSearch,
  }) {
    return SettingsModel(
      languageCode: languageCode ?? this.languageCode,
      generalNotifications: generalNotifications ?? this.generalNotifications,
      assignmentAlerts: assignmentAlerts ?? this.assignmentAlerts,
      deadlineReminders: deadlineReminders ?? this.deadlineReminders,
      announcements: announcements ?? this.announcements,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      showProfile: showProfile ?? this.showProfile,
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      allowSearch: allowSearch ?? this.allowSearch,
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
    showProfile,
    showEmail,
    showPhone,
    allowSearch,
  ];
}
