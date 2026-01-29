import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/setting/data/model/change_password_response_model.dart';
import 'package:my_template/features/setting/data/model/settings_model.dart';

abstract class SettingsRepo {
  Future<Either<Failure, ChangePasswordResponseModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
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

class SettingsRepoImpl extends SettingsRepo {
  final ApiConsumer apiConsumer;
  SettingsRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, ChangePasswordResponseModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.changePassword,
          body: {
            "OldPassword": oldPassword,
            "NewPassword": newPassword,
            "ConfirmPassword": confirmNewPassword,
          },
        );
        return ChangePasswordResponseModel.fromJson(response);
      },
    );
  }
}
