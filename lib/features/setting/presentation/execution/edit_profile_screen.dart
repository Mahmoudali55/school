// lib/features/settings/presentation/screens/edit_profile_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'أحمد المدير');
  final _emailController = TextEditingController(text: 'admin@school.edu');
  final _phoneController = TextEditingController(text: '+966500000000');
  final _positionController = TextEditingController(text: 'مدير المدرسة');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.edit_profile.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // صورة الملف الشخصي
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColor.primaryColor(context).withOpacity(0.1),
                    child: Icon(Icons.school, size: 50.w, color: AppColor.primaryColor(context)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: AppColor.primaryColor(context),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 12.w,
                          color: AppColor.whiteColor(context),
                        ),
                        onPressed: _changeProfilePicture,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // الاسم الكامل
              CustomFormField(
                radius: 12.r,
                controller: _nameController,
                title: AppLocalKay.full_name.tr(),
                prefixIcon: Icon(Icons.person),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_full_name.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // البريد الإلكتروني
              CustomFormField(
                controller: _emailController,
                title: AppLocalKay.email.tr(),
                prefixIcon: Icon(Icons.email),
                radius: 12.r,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_email.tr();
                  }
                  if (!value.contains('@')) {
                    return AppLocalKay.enter_valid_email.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رقم الهاتف
              CustomFormField(
                radius: 12.r,
                controller: _phoneController,
                title: AppLocalKay.phone.tr(),
                prefixIcon: Icon(Icons.phone),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_phone.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // المنصب
              CustomFormField(
                radius: 12.r,
                controller: _positionController,
                title: AppLocalKay.position.tr(),
                prefixIcon: Icon(Icons.work),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_position.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              CustomButton(
                text: AppLocalKay.save_changes.tr(),
                onPressed: _saveProfile,
                radius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    // TODO: إضافة وظيفة تغيير صورة الملف الشخصي
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ التغييرات بنجاح'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }
}
