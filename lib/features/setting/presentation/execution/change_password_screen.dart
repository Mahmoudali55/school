// lib/features/settings/presentation/screens/change_password_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.change_password.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كلمة المرور الحالية
              CustomFormField(
                controller: _currentPasswordController,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
                isPassword: _obscureCurrentPassword,
                title: AppLocalKay.current_password.tr(),
                radius: 12.r,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_current_password.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // كلمة المرور الجديدة
              CustomFormField(
                controller: _newPasswordController,
                isPassword: _obscureNewPassword,
                title: AppLocalKay.new_password.tr(),
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                radius: 12.r,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_new_password.tr();
                  }
                  if (value.length < 6) {
                    return AppLocalKay.password_length.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // تأكيد كلمة المرور
              CustomFormField(
                controller: _confirmPasswordController,
                isPassword: _obscureConfirmPassword,
                title: AppLocalKay.new_password.tr(),
                prefixIcon: Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                radius: 12.r,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_new_password.tr();
                  }
                  if (value != _newPasswordController.text) {
                    return AppLocalKay.password_not_match.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // نصائح الأمان
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalKay.suggestions.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalKay.suggestions_content.tr(),
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              CustomButton(
                text: AppLocalKay.change_password.tr(),
                radius: 16.r,
                color: AppColor.primaryColor(context),
                onPressed: _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: تنفيذ تغيير كلمة المرور
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تغيير كلمة المرور بنجاح'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
