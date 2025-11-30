import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
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
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, required this.selectedUserType});

  final _formKey = GlobalKey<FormState>();
  final UserTypeModel selectedUserType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 280.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor(context),
                  AppColor.primaryColor(context).withOpacity(0.8),
                  AppColor.secondAppColor(context),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    size: 32.w,
                    color: AppColor.whiteColor(context),
                  ),
                ),
                Gap(16.h),
                Text(
                  AppLocalKay.welcomeBack.tr(),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.whiteColor(context),
                    height: 1.2,
                  ),
                ),
                Gap(8.h),
                Text(
                  "${AppLocalKay.loginToContinue.tr()}${selectedUserType.title}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.whiteColor(context).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.loginStatus.isSuccess) {
                    CommonMethods.showToast(
                      message: state.loginStatus.data?.message ?? "Login success",
                    );
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputField(
                          context,
                          controller: cubit.mobileController,
                          label: AppLocalKay.email.tr(),
                          icon: Icons.email_outlined,
                          validator: (value) => value!.isEmpty ? AppLocalKay.enterEmail.tr() : null,
                        ),
                        Gap(16.h),
                        _buildInputField(
                          context,
                          controller: cubit.passwordController,
                          label: AppLocalKay.password.tr(),
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) =>
                              value!.isEmpty ? AppLocalKay.enterPassword.tr() : null,
                        ),
                        Gap(16.h),
                        _buildBottomOptions(context, cubit),
                        Gap(24.h),
                        _buildLoginButton(context, cubit, state),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return CustomFormField(
      title: label,
      hintText: label,
      controller: controller,
      isPassword: isPassword,
      validator: validator,
      prefixIcon: Icon(icon, color: AppColor.iconColor(context), size: 24.w),
    );
  }

  Widget _buildBottomOptions(BuildContext context, AuthCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: cubit.state.rememberMe,
              onChanged: (value) => cubit.changeRememberMe(),
              activeColor: AppColor.primaryColor(context),
              checkColor: AppColor.whiteColor(context),
            ),

            Gap(8.w),
            Text(
              AppLocalKay.rememberMe.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.textSecondary(context)),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            NavigatorMethods.pushNamed(context, RoutesName.forgetPasswordScreen);
          },
          child: Text(
            AppLocalKay.forgotPassword.tr(),
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthCubit cubit, AuthState state) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primaryColor(context), AppColor.secondAppColor(context)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: CustomButton(
        radius: 16,
        text: AppLocalKay.login.tr(),
        cubitState: cubit.state.loginStatus,
        onPressed: () {
          NavigatorMethods.pushNamed(context, RoutesName.layoutScreen, arguments: selectedUserType);
          // if (_formKey.currentState!.validate()) {
          //   cubit.login(context: context);
          // }
        },
        color: Colors.transparent,
      ),
    );
  }
}
