part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final StatusState<AuthResponseModel> loginStatus;

  const AuthState({this.loginStatus = const StatusState.initial()});

  AuthState copyWith({StatusState<AuthResponseModel>? loginStatus}) {
    return AuthState(loginStatus: loginStatus ?? this.loginStatus);
  }

  @override
  List<Object?> get props => [loginStatus];
}
