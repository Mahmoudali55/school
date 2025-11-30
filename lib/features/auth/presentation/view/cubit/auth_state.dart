import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/model/user_model.dart';

class AuthState extends Equatable {
  final StatusState<AuthResponseModel> loginStatus;
  final bool rememberMe;

  const AuthState({this.loginStatus = const StatusState.initial(), this.rememberMe = false});

  AuthState copyWith({StatusState<AuthResponseModel>? loginStatus, bool? rememberMe}) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [loginStatus, rememberMe];
}
