import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/model/level_model.dart';
import 'package:my_template/features/auth/data/model/nationality_model.dart';
import 'package:my_template/features/auth/data/model/registration_response_model.dart';
import 'package:my_template/features/auth/data/model/religion_model.dart';
import 'package:my_template/features/auth/data/model/section_model.dart';
import 'package:my_template/features/auth/data/model/stage_model.dart';
import 'package:my_template/features/auth/data/model/user_login_model.dart';

class AuthState extends Equatable {
  final bool rememberMe;

  /// Auth
  final StatusState<UserLoginModel> loginStatus;
  final StatusState<RegistrationResponse> registerStatus;
  final StatusState<dynamic> admissionStatus;
  final StatusState<List<ReligionModel>> religionStatus;
  final StatusState<List<NationalityModel>> nationalityStatus;
  final StatusState<List<SectionModel>> sectionStatus;
  final StatusState<Map<int, List<StageModel>>> stagesMapStatus;
  final StatusState<Map<String, List<LevelModel>>> levelsMapStatus;

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
    this.admissionStatus = const StatusState.initial(),
    this.religionStatus = const StatusState.initial(),
    this.nationalityStatus = const StatusState.initial(),
    this.sectionStatus = const StatusState.initial(),
    this.stagesMapStatus = const StatusState.initial(),
    this.levelsMapStatus = const StatusState.initial(),

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
    StatusState<UserLoginModel>? loginStatus,
    StatusState<RegistrationResponse>? registerStatus,
    StatusState<dynamic>? admissionStatus,
    StatusState<List<ReligionModel>>? religionStatus,
    StatusState<List<NationalityModel>>? nationalityStatus,
    StatusState<List<SectionModel>>? sectionStatus,
    StatusState<Map<int, List<StageModel>>>? stagesMapStatus,
    StatusState<Map<String, List<LevelModel>>>? levelsMapStatus,

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
      admissionStatus: admissionStatus ?? this.admissionStatus,
      religionStatus: religionStatus ?? this.religionStatus,
      nationalityStatus: nationalityStatus ?? this.nationalityStatus,
      sectionStatus: sectionStatus ?? this.sectionStatus,
      stagesMapStatus: stagesMapStatus ?? this.stagesMapStatus,
      levelsMapStatus: levelsMapStatus ?? this.levelsMapStatus,

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
    admissionStatus,
    religionStatus,
    nationalityStatus,
    sectionStatus,
    stagesMapStatus,
    levelsMapStatus,
    hasUpperCase,
    hasLowerCase,
    hasNumber,
    hasSpecialChar,
    hasMinLength,
    isPasswordMatch,
    isBirthDateSelected,
  ];
}
