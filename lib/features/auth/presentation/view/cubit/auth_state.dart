import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/model/user_model.dart';

class AuthState extends Equatable {
  final bool rememberMe;
  final StatusState<AuthResponseModel> loginStatus;

  const AuthState({this.rememberMe = false, this.loginStatus = const StatusState.initial()});

  AuthState copyWith({bool? rememberMe, StatusState<AuthResponseModel>? loginStatus}) {
    return AuthState(
      rememberMe: rememberMe ?? this.rememberMe,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }

  @override
  List<Object?> get props => [rememberMe, loginStatus];
}
