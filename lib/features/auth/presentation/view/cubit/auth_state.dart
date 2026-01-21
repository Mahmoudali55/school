import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/model/registration_response_model.dart';

class AuthState extends Equatable {
  final bool rememberMe;

  /// Auth
  final StatusState<RegistrationResponse> loginStatus;
  final StatusState<RegistrationResponse> registerStatus;

  /// Password validation
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool hasMinLength;

  /// Confirm password
  final bool isPasswordMatch;

  /// Birth date
  final bool isBirthDateSelected;

  const AuthState({
    this.rememberMe = false,
    this.loginStatus = const StatusState.initial(),
    this.registerStatus = const StatusState.initial(),

    this.hasUpperCase = false,
    this.hasLowerCase = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
    this.hasMinLength = false,

    this.isPasswordMatch = false,
    this.isBirthDateSelected = false,
  });

  bool get isPasswordValid =>
      hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar && hasMinLength;

  AuthState copyWith({
    bool? rememberMe,
    StatusState<RegistrationResponse>? loginStatus,
    StatusState<RegistrationResponse>? registerStatus,

    bool? hasUpperCase,
    bool? hasLowerCase,
    bool? hasNumber,
    bool? hasSpecialChar,
    bool? hasMinLength,

    bool? isPasswordMatch,
    bool? isBirthDateSelected,
  }) {
    return AuthState(
      rememberMe: rememberMe ?? this.rememberMe,
      loginStatus: loginStatus ?? this.loginStatus,
      registerStatus: registerStatus ?? this.registerStatus,

      hasUpperCase: hasUpperCase ?? this.hasUpperCase,
      hasLowerCase: hasLowerCase ?? this.hasLowerCase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      hasMinLength: hasMinLength ?? this.hasMinLength,

      isPasswordMatch: isPasswordMatch ?? this.isPasswordMatch,
      isBirthDateSelected: isBirthDateSelected ?? this.isBirthDateSelected,
    );
  }

  @override
  List<Object?> get props => [
    rememberMe,
    loginStatus,
    registerStatus,
    hasUpperCase,
    hasLowerCase,
    hasNumber,
    hasSpecialChar,
    hasMinLength,
    isPasswordMatch,
    isBirthDateSelected,
  ];
}
