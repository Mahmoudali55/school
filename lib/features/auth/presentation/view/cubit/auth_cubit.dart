import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/model/admission_request_model.dart';
import 'package:my_template/features/auth/data/model/edit_fCM_request_model.dart';
import 'package:my_template/features/auth/data/model/level_model.dart';
import 'package:my_template/features/auth/data/model/parent_registration_model.dart';
import 'package:my_template/features/auth/data/model/stage_model.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const AuthState());

  final TextEditingController usernameLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController nationalIdController = TextEditingController();
  void clearRegisterFields() {
    userNameController.clear();
    nationalIdController.clear();
    emailController.clear();
    registerPasswordController.clear();
    confirmPasswordController.clear();

    emit(
      state.copyWith(
        hasUpperCase: false,
        hasLowerCase: false,
        hasNumber: false,
        hasSpecialChar: false,
        hasMinLength: false,
        isPasswordMatch: false,
        registerStatus: const StatusState.initial(),
      ),
    );
  }

  void clearLoginFields() {
    usernameLoginController.clear();
    passwordLoginController.clear();
    emit(state.copyWith(loginStatus: const StatusState.initial()));
  }

  void validateRegisterPassword(String value) {
    emit(
      state.copyWith(
        hasUpperCase: value.contains(RegExp(r'[A-Z]')),
        hasLowerCase: value.contains(RegExp(r'[a-z]')),
        hasNumber: value.contains(RegExp(r'[0-9]')),
        hasSpecialChar: value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
        hasMinLength: value.length >= 8,
      ),
    );

    validateConfirmPassword(confirmPasswordController.text);
  }

  void validateConfirmPassword(String value) {
    emit(state.copyWith(isPasswordMatch: value == registerPasswordController.text));
  }

  void changeRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  // Future<void> login(BuildContext context) async {
  //   emit(state.copyWith(loginStatus: StatusState.loading()));

  //   final result = await authRepo.login(
  //     mobile: mobileController.text,
  //     password: passwordController.text,
  //     rememberMe: state.rememberMe,
  //     accountType: accountTypeController.text,
  //   );

  //   result.fold(
  //     (error) => emit(state.copyWith(loginStatus: StatusState.failure(error.errMessage))),
  //     (success) {
  //       emit(state.copyWith(loginStatus: StatusState.success(success)));
  //     },
  //   );
  // }

  Future<void> register(BuildContext context) async {
    if (isClosed) return;
    emit(state.copyWith(registerStatus: StatusState.loading()));

    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }
    final result = await authRepo.register(
      username: userNameController.text,
      nationalId: nationalIdController.text,
      password: registerPasswordController.text,
      email: emailController.text,
      fcmToken: fcmToken,
    );

    if (isClosed) return;
    result.fold(
      (error) {
        final errorMessage = error.errMessage ?? "Register failed";
        if (!isClosed) {
          emit(state.copyWith(registerStatus: StatusState.failure(errorMessage)));
        }
      },
      (success) {
        if (!isClosed) {
          emit(state.copyWith(registerStatus: StatusState.success(success)));
        }
      },
    );
  }

  Future<void> login(BuildContext context) async {
    if (isClosed) return;
    emit(state.copyWith(loginStatus: StatusState.loading()));

    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }
    final result = await authRepo.login(
      username: usernameLoginController.text,
      password: passwordLoginController.text,
      fcmToken: fcmToken,
    );

    if (isClosed) return;
    await result.fold(
      (error) async {
        final errorMessage = error.errMessage ?? "Login failed";
        if (!isClosed) {
          emit(state.copyWith(loginStatus: StatusState.failure(errorMessage)));
        }
      },
      (success) async {
        if (!isClosed) {
          _saveUserData(success);
          print("======= [DEBUG] Starting editFcm after login =======");
          await editFcm(EditFCMModel(userId: success.userId, fcm: fcmToken ?? ""));
          print("======= [DEBUG] editFcm call finished =======");
          usernameLoginController.clear();
          passwordLoginController.clear();
          emit(state.copyWith(loginStatus: StatusState.success(success)));
        }
      },
    );
  }

  void _saveUserData(dynamic data) {
    final token = data?.accessToken ?? "";
    HiveMethods.updateToken(token);

    final type = (data?.type ?? "").trim();
    HiveMethods.updateType(type);

    final userId = data?.userId ?? "";
    HiveMethods.updateUserid(userId);
    final userName = data?.userName ?? "";
    HiveMethods.updateUserName(userName);

    final name = data?.name ?? "";
    HiveMethods.updateName(name);

    final code = data?.code ?? "";
    HiveMethods.updateUserCode(code);

    final compneyName = data?.compneyName ?? "";
    HiveMethods.updateUserCompanyName(compneyName);

    final levelCode = data?.levelCode ?? "";
    HiveMethods.updateUserLevelCode(levelCode);

    final sectionCode = data?.sectionCode ?? "";
    HiveMethods.updateUserSection(sectionCode);

    final stageCode = data?.stageCode ?? "";
    HiveMethods.updateUserStage(stageCode);

    final classCode = data?.classCode ?? "";
    HiveMethods.updateUserClassCode(classCode);
  }

  String getRouteType() {
    final type = (state.loginStatus.data?.type ?? "").trim();
    if (type == "1" || type == "student") {
      return "student";
    } else if (type == "2" || type == "parent") {
      return "parent";
    } else if (type == "3" || type == "teacher") {
      return "teacher";
    }
    return "admin";
  }

  Future<void> submitAdmissionRequest(AdmissionRequestModel model) async {
    if (isClosed) return;
    emit(state.copyWith(admissionStatus: const StatusState.loading()));

    final result = await authRepo.submitAdmissionRequest(admissionRequestModel: model);

    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(admissionStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(admissionStatus: StatusState.success(success))),
    );
  }

  void clearAdmissionStatus() {
    emit(state.copyWith(admissionStatus: const StatusState.initial()));
  }

  Future<void> loadReligionCodes() async {
    if (isClosed) return;
    emit(state.copyWith(religionStatus: const StatusState.loading()));
    final result = await authRepo.getReligionCodes();
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(religionStatus: StatusState.failure(error.errMessage))),
      (data) => emit(state.copyWith(religionStatus: StatusState.success(data))),
    );
  }

  Future<void> loadNationalityCodes() async {
    if (isClosed) return;
    emit(state.copyWith(nationalityStatus: const StatusState.loading()));
    final result = await authRepo.getNationalityCodes();
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(nationalityStatus: StatusState.failure(error.errMessage))),
      (data) => emit(state.copyWith(nationalityStatus: StatusState.success(data))),
    );
  }

  Future<void> loadSections() async {
    if (isClosed) return;
    emit(state.copyWith(sectionStatus: const StatusState.loading()));
    final result = await authRepo.getSections();
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(sectionStatus: StatusState.failure(error.errMessage))),
      (data) => emit(state.copyWith(sectionStatus: StatusState.success(data))),
    );
  }

  Future<void> loadStages(int sectionCode) async {
    if (isClosed) return;

    // Check if data already exists in map
    final currentMap = state.stagesMapStatus.data ?? {};
    if (currentMap.containsKey(sectionCode)) return;

    // Set loading state for the map if needed or just fetch
    emit(state.copyWith(stagesMapStatus: state.stagesMapStatus.copyWith(status: Status.loading)));

    final result = await authRepo.getStages(sectionCode);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          stagesMapStatus: state.stagesMapStatus.copyWith(
            status: Status.failure,
            error: error.errMessage,
          ),
        ),
      ),
      (data) {
        final newMap = Map<int, List<StageModel>>.from(state.stagesMapStatus.data ?? {});
        newMap[sectionCode] = data;
        emit(state.copyWith(stagesMapStatus: StatusState.success(newMap)));
      },
    );
  }

  Future<void> loadLevels(int sectionCode, int stageCode) async {
    if (isClosed) return;

    final key = "${sectionCode}_$stageCode";
    final currentMap = state.levelsMapStatus.data ?? {};
    if (currentMap.containsKey(key)) return;

    emit(state.copyWith(levelsMapStatus: state.levelsMapStatus.copyWith(status: Status.loading)));

    final result = await authRepo.getLevels(sectionCode, stageCode);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          levelsMapStatus: state.levelsMapStatus.copyWith(
            status: Status.failure,
            error: error.errMessage,
          ),
        ),
      ),
      (data) {
        final newMap = Map<String, List<LevelModel>>.from(state.levelsMapStatus.data ?? {});
        newMap[key] = data;
        emit(state.copyWith(levelsMapStatus: StatusState.success(newMap)));
      },
    );
  }

  Future<void> registerParent(ParentRegistrationModel parentRegistrationModel) async {
    if (isClosed) return;
    emit(state.copyWith(admissionStatus: const StatusState.loading()));
    final result = await authRepo.registerParent(parentRegistrationModel: parentRegistrationModel);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(admissionStatus: StatusState.failure(error.errMessage))),
      (data) => emit(state.copyWith(admissionStatus: StatusState.success(data))),
    );
  }

  Future<void> editFcm(EditFCMModel editFCMModel) async {
    if (isClosed) return;
    print("Executing editFcm with model: ${editFCMModel.toJson()}");
    emit(state.copyWith(fcmStatus: const StatusState.loading()));
    final result = await authRepo.editFCM(editFCMModel: editFCMModel);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(fcmStatus: StatusState.failure(error.errMessage))),
      (data) => emit(state.copyWith(fcmStatus: StatusState.success(data))),
    );
  }
}
