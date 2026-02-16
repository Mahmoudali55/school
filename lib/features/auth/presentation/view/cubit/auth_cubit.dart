import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/network/status.state.dart';
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

    final result = await authRepo.register(
      username: userNameController.text,
      nationalId: nationalIdController.text,
      password: registerPasswordController.text,
      email: emailController.text,
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

    final result = await authRepo.login(
      username: usernameLoginController.text,
      password: passwordLoginController.text,
    );

    if (isClosed) return;
    result.fold(
      (error) {
        final errorMessage = error.errMessage ?? "Login failed";
        if (!isClosed) {
          emit(state.copyWith(loginStatus: StatusState.failure(errorMessage)));
        }
      },
      (success) {
        if (!isClosed) {
          _saveUserData(success);
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
}
