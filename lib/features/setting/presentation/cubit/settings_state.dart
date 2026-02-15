import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/setting/data/model/change_password_response_model.dart';
import 'package:my_template/features/setting/data/model/settings_model.dart';

class SettingsState extends Equatable {
  final StatusState<ChangePasswordResponseModel> changePasswordStatus;
  final StatusState<String> logoutStatus;
  final SettingsModel? settings;

  const SettingsState({
    this.changePasswordStatus = const StatusState.initial(),
    this.settings,
    this.logoutStatus = const StatusState.initial(),
  });

  SettingsState copyWith({
    StatusState<ChangePasswordResponseModel>? changePasswordStatus,
    StatusState<String>? logoutStatus,
    SettingsModel? settings,
  }) {
    return SettingsState(
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      settings: settings ?? this.settings,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [changePasswordStatus, settings, logoutStatus];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}
