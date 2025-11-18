import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';

import '../../../data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const AuthState());

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();

  set mobile(String mobile) => mobileController.text = mobile;
  set password(String password) => passwordController.text = password;
  set accountType(String accountType) =>
      accountTypeController.text = accountType;

  bool rememberMe = false;

  void changeRememberMe() {
    rememberMe = !rememberMe;
    emit(state.copyWith());
  }

  Future<void> login({BuildContext? context}) async {
    emit(state.copyWith(loginStatus: StatusState.loading()));

    final result = await authRepo.login(
      mobile: mobileController.text,
      password: passwordController.text,
      rememberMe: rememberMe,
      accountType: accountTypeController.text,
    );
    result.fold(
      (error) => emit(
        state.copyWith(loginStatus: StatusState.failure(error.errMessage)),
      ),
      (success) {
        emit(state.copyWith(loginStatus: StatusState.success(success)));
      },
    );
  }
}
