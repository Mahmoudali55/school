import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget passwordRule(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: isValid ? Colors.green : Colors.grey, fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.register.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.registerStatus.isSuccess) {
                CommonMethods.showToast(
                  message: AppLocalKay.registerSuccess.tr(),
                  type: ToastType.success,
                );

                context.read<AuthCubit>().clearRegisterFields();

                NavigatorMethods.pushNamed(context, RoutesName.loginScreen);
              }

              if (state.registerStatus.isFailure) {
                CommonMethods.showToast(
                  message: state.registerStatus.error ?? "Register failed",
                  type: ToastType.error,
                );
              }
            },

            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Username
                  CustomFormField(
                    title: AppLocalKay.username.tr(),
                    controller: cubit.userNameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) => value!.isEmpty ? AppLocalKay.username.tr() : null,
                  ),
                  const Gap(16),

                  /// National ID
                  CustomFormField(
                    title: AppLocalKay.nationalId.tr(),
                    controller: cubit.nationalIdController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalKay.nationalId.tr();
                      }
                      if (value.length < 10) {
                        return AppLocalKay.nationalId_invalid.tr();
                      }
                      return null;
                    },
                  ),
                  const Gap(16),
                  CustomFormField(
                    title: AppLocalKay.email.tr(),
                    controller: cubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) => value!.isEmpty ? AppLocalKay.email.tr() : null,
                  ),

                  /// Password
                  CustomFormField(
                    title: AppLocalKay.password.tr(),
                    controller: cubit.registerPasswordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    onChanged: cubit.validateRegisterPassword,
                    validator: (value) => value!.isEmpty ? AppLocalKay.password.tr() : null,
                  ),
                  const Gap(8),

                  /// Password Rules
                  passwordRule(AppLocalKay.uppercase.tr(), state.hasUpperCase),
                  passwordRule(AppLocalKay.lowercase.tr(), state.hasLowerCase),
                  passwordRule(AppLocalKay.number.tr(), state.hasNumber),
                  passwordRule(AppLocalKay.special.tr(), state.hasSpecialChar),
                  passwordRule(AppLocalKay.min_length.tr(), state.hasMinLength),
                  const Gap(16),

                  /// Confirm Password
                  CustomFormField(
                    title: AppLocalKay.confirmPassword.tr(),
                    controller: cubit.confirmPasswordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    onChanged: cubit.validateConfirmPassword,
                    validator: (value) => value!.isEmpty ? AppLocalKay.confirmPassword.tr() : null,
                    suffixIcon: cubit.confirmPasswordController.text.isEmpty
                        ? null
                        : Icon(
                            state.isPasswordMatch ? Icons.check_circle : Icons.error,
                            color: state.isPasswordMatch ? Colors.green : Colors.red,
                          ),
                  ),
                  const Gap(16),

                  /// Register Button
                  CustomButton(
                    radius: 12.r,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (!state.isPasswordMatch) {
                        CommonMethods.showToast(
                          message: AppLocalKay.password_not_match.tr(),
                          type: ToastType.error,
                        );
                        return;
                      }

                      if (!state.isPasswordValid) {
                        CommonMethods.showToast(
                          message: AppLocalKay.password_rules_not_valid.tr(),
                          type: ToastType.error,
                        );
                        return;
                      }

                      cubit.register(context);
                    },

                    text: AppLocalKay.register.tr(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
