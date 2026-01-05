import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/features/setting/data/model/settings_model.dart';

class SettingsRepo {
  SettingsModel getSettings() {
    return SettingsModel(
      languageCode: HiveMethods.getLang(),
      generalNotifications: HiveMethods.getNotificationSetting('generalNotifications'),
      assignmentAlerts: HiveMethods.getNotificationSetting('assignmentAlerts'),
      deadlineReminders: HiveMethods.getNotificationSetting('deadlineReminders'),
      announcements: HiveMethods.getNotificationSetting('announcements'),
      emailNotifications: HiveMethods.getNotificationSetting('emailNotifications'),
    );
  }

  void updateLanguage(String code) {
    HiveMethods.updateLang(Locale(code));
  }

  void updateNotificationSetting(String key, bool value) {
    HiveMethods.updateNotificationSetting(key, value);
  }
}
