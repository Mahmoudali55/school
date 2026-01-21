import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.login.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.loginStatus.isSuccess) {
                  // CommonMethods.showToast(
                  //   message: state.loginStatus.data?.message ?? "Login success",
                  // );
                  NavigatorMethods.pushNamed(context, RoutesName.homeScreen);
                }
                if (state.loginStatus.isFailure) {
                  log(state.loginStatus.error?.toString() ?? "Login error");
                  final error = state.loginStatus.error ?? "Login failed";
                  CommonMethods.showToast(message: error, type: ToastType.error);
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/global_icon/graduate.png',
                        height: 150.h,
                        width: 150.w,
                        color: AppColor.primaryColor(context),
                      ),
                      Gap(16.h),
                      CustomFormField(
                        controller: cubit.mobileController,
                        title: AppLocalKay.email.tr(),
                        prefixIcon: Icon(Icons.email_outlined),
                        validator: (value) => value!.isEmpty ? AppLocalKay.enterEmail.tr() : null,
                      ),
                      Gap(16.h),
                      CustomFormField(
                        controller: cubit.passwordController,
                        title: AppLocalKay.password.tr(),
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: true,
                        validator: (value) =>
                            value!.isEmpty ? AppLocalKay.enterPassword.tr() : null,
                      ),
                      Gap(16.h),
                      _buildBottomOptions(context, cubit),
                      Gap(24.h),
                      _buildLoginButton(context, cubit, state),
                      Gap(24.h),
                      _buildSignUpLink(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalKay.dontHaveAccount.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.textSecondary(context)),
        ),
        TextButton(
          onPressed: () => NavigatorMethods.pushNamed(context, RoutesName.registerScreen),
          child: Text(
            AppLocalKay.register.tr(),
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomOptions(BuildContext context, AuthCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(value: cubit.state.rememberMe, onChanged: (_) => cubit.changeRememberMe()),
            Gap(8.w),
            Text(
              AppLocalKay.rememberMe.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.textSecondary(context)),
            ),
          ],
        ),
        // TextButton(
        //   onPressed: () {
        //     NavigatorMethods.pushNamed(context, RoutesName.forgetPasswordScreen);
        //   },
        //   child: Text(
        //     AppLocalKay.forgotPassword.tr(),
        //     style: AppTextStyle.bodyMedium(
        //       context,
        //     ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.w600),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthCubit cubit, AuthState state) {
    return CustomButton(
      radius: 16,
      text: AppLocalKay.login.tr(),
      cubitState: cubit.state.loginStatus,
      onPressed: () {
        NavigatorMethods.pushNamed(context, RoutesName.layoutScreen);
        // if (_formKey.currentState!.validate()) {
        //   cubit.login(context: context);
        // }
      },
    );
  }
}
