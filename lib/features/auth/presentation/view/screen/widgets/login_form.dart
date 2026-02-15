import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFormField(
                controller: cubit.usernameLoginController,
                title: AppLocalKay.username.tr(),
                prefixIcon: const Icon(Icons.person_2_outlined),
                validator: (value) => value!.isEmpty ? AppLocalKay.enterEmail.tr() : null,
              ),
              Gap(16.h),
              CustomFormField(
                controller: cubit.passwordLoginController,
                title: AppLocalKay.password.tr(),
                prefixIcon: const Icon(Icons.lock_outline),
                isPassword: true,
                validator: (value) => value!.isEmpty ? AppLocalKay.enterPassword.tr() : null,
              ),
              Gap(24.h),
              CustomButton(
                radius: 16,
                text: AppLocalKay.login.tr(),
                cubitState: state.loginStatus,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.login(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
