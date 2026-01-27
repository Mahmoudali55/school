import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/setting/data/model/settings_model.dart';
import 'package:my_template/features/setting/data/repo/settings_repo.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _settingsRepo;

  SettingsCubit(this._settingsRepo) : super(SettingsInitial());

  void loadSettings() {
    final settings = _settingsRepo.getSettings();
    emit(SettingsLoaded(settings));
  }

  void updateLanguage(String code) {
    if (state is SettingsLoaded) {
      _settingsRepo.updateLanguage(code);
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(languageCode: code)));
    }
  }

  void toggleNotification(String key, bool value) {
    if (state is SettingsLoaded) {
      _settingsRepo.updateNotificationSetting(key, value);
      final currentSettings = (state as SettingsLoaded).settings;

      SettingsModel updatedSettings;
      switch (key) {
        case 'generalNotifications':
          updatedSettings = currentSettings.copyWith(generalNotifications: value);
          break;
        case 'assignmentAlerts':
          updatedSettings = currentSettings.copyWith(assignmentAlerts: value);
          break;
        case 'deadlineReminders':
          updatedSettings = currentSettings.copyWith(deadlineReminders: value);
          break;
        case 'announcements':
          updatedSettings = currentSettings.copyWith(announcements: value);
          break;
        case 'emailNotifications':
          updatedSettings = currentSettings.copyWith(emailNotifications: value);
          break;
        default:
          updatedSettings = currentSettings;
      }
      emit(SettingsLoaded(updatedSettings));
    }
  }

  Future<void> changePassword(
    BuildContext context,
    String oldPasswordController,
    String newPasswordController,
    String confirmPasswordController,
  ) async {
    emit(state.copyWith(changePasswordStatus: StatusState.loading()));

    final result = await _settingsRepo.changePassword(
      oldPassword: oldPasswordController,
      newPassword: newPasswordController,
      confirmNewPassword: confirmPasswordController,
    );
    result.fold(
      (error) {
        final errorMessage = error.errMessage ?? "Register failed";
        emit(state.copyWith(changePasswordStatus: StatusState.failure(errorMessage)));
      },
      (success) {
        emit(state.copyWith(changePasswordStatus: StatusState.success(success)));
      },
    );
  }
}
