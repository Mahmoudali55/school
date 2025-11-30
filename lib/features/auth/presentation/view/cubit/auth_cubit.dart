import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const AuthState());

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();

  void changeRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> login(BuildContext context) async {
    emit(state.copyWith(loginStatus: StatusState.loading()));

    final result = await authRepo.login(
      mobile: mobileController.text,
      password: passwordController.text,
      rememberMe: state.rememberMe,
      accountType: accountTypeController.text,
    );

    result.fold(
      (error) => emit(state.copyWith(loginStatus: StatusState.failure(error.errMessage))),
      (success) {
        emit(state.copyWith(loginStatus: StatusState.success(success)));
      },
    );
  }

  @override
  Future<void> close() {
    mobileController.dispose();
    passwordController.dispose();
    accountTypeController.dispose();
    return super.close();
  }
}
