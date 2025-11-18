import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.loginStatus.isSuccess) {
              CommonMethods.showToast(
                message:
                    state.loginStatus.data?.message ??
                    "Login success=============",
              );
              NavigatorMethods.pushNamed(context, RoutesName.homeScreen);
            }
            if (state.loginStatus.isFailure) {
              log(
                state.loginStatus.error?.toString() ??
                    "-----------------------------",
              );
              final error = state.loginStatus.error ?? "Login failed";
              CommonMethods.showToast(message: error, type: ToastType.error);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  CustomFormField(
                    controller: cubit.mobileController,
                    title: 'Mobile',
                    prefixIcon: const Icon(Icons.phone),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter mobile' : null,
                  ),
                  CustomFormField(
                    controller: cubit.passwordController,
                    title: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    isPassword: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter password' : null,
                  ),
                  CustomFormField(
                    controller: cubit.accountTypeController,
                    title: 'Account Type',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter account type' : null,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: cubit.rememberMe,
                        onChanged: (value) => cubit.changeRememberMe(),
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  CustomButton(
                    text: "login",
                    cubitState: cubit.state.loginStatus,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.login(context: context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
