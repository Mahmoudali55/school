import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
    emit(state.copyWith(registerStatus: StatusState.loading()));

    final result = await authRepo.register(
      username: userNameController.text,
      nationalId: int.parse(nationalIdController.text),
      password: registerPasswordController.text,
      email: emailController.text,
    );

    result.fold(
      (error) {
        final errorMessage = error.errMessage ?? "Register failed";
        emit(state.copyWith(registerStatus: StatusState.failure(errorMessage)));
      },
      (success) {
        emit(state.copyWith(registerStatus: StatusState.success(success)));
      },
    );
  }

  Future<void> login(BuildContext context) async {
    emit(state.copyWith(loginStatus: StatusState.loading()));

    final result = await authRepo.login(
      username: usernameLoginController.text,
      password: passwordLoginController.text,
    );

    result.fold(
      (error) {
        final errorMessage = error.errMessage;
        emit(state.copyWith(loginStatus: StatusState.failure(errorMessage)));
      },
      (success) {
        emit(state.copyWith(loginStatus: StatusState.success(success)));
      },
    );
  }
}
