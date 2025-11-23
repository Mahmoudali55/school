import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor(context),
                  AppColor.primaryColor(context).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 27.h),
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
                  child: Icon(Icons.lock_outline, size: 32.w, color: AppColor.whiteColor(context)),
                ),
                Gap(16.h),
                Text(
                  AppLocalKay.forgotPassword.tr(),
                  style: AppTextStyle.bodyLarge(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context)),
                ),
                Gap(8.h),
                Text(
                  AppLocalKay.enterNewPassword.tr(),
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPasswordField(
                        context,
                        controller: passwordController,
                        label: AppLocalKay.newPassword.tr(),
                      ),
                      Gap(16.h),

                      _buildPasswordField(
                        context,
                        controller: confirmPasswordController,
                        label: AppLocalKay.confirmPassword.tr(),
                        validator: (value) {
                          if (value!.isEmpty) return AppLocalKay.enterNewPassword.tr();
                          if (value != passwordController.text)
                            return AppLocalKay.passwordNotMatch.tr();
                          return null;
                        },
                      ),
                      Gap(24.h),

                      Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.primaryColor(context),
                              AppColor.secondAppColor(context),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: CustomButton(
                          height: 20,
                          radius: 12,
                          text: AppLocalKay.resetPassword.tr(),
                          cubitState: cubit.state.loginStatus,
                          onPressed: () {},
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(8.h),
        CustomFormField(
          hintText: label,
          radius: 12,
          controller: controller,
          title: label,
          isPassword: true,
          validator: validator,
          prefixIcon: Icon(Icons.lock_outline, color: AppColor.iconColor(context)),
        ),
      ],
    );
  }
}
