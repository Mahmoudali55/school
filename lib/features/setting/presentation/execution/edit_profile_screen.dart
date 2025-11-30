// lib/features/settings/presentation/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
          'تعديل الملف الشخصي',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveProfile)],
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
                title: 'الاسم الكامل',
                prefixIcon: Icon(Icons.person),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الكامل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // البريد الإلكتروني
              CustomFormField(
                controller: _emailController,
                title: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email),
                radius: 12.r,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رقم الهاتف
              CustomFormField(
                radius: 12.r,
                controller: _phoneController,
                title: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // المنصب
              CustomFormField(
                radius: 12.r,
                controller: _positionController,
                title: 'المنصب',
                prefixIcon: Icon(Icons.work),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المنصب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              CustomButton(text: 'حفظ التغييرات', radius: 12.r),
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
