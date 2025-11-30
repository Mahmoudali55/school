// lib/features/settings/presentation/screens/school_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class SchoolInfoScreen extends StatefulWidget {
  const SchoolInfoScreen({super.key});

  @override
  State<SchoolInfoScreen> createState() => _SchoolInfoScreenState();
}

class _SchoolInfoScreenState extends State<SchoolInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController(text: 'مدرسة النموذجية');
  final _schoolIdController = TextEditingController(text: 'SCH-12345');
  final _addressController = TextEditingController(text: 'الرياض، حي العليا');
  final _phoneController = TextEditingController(text: '+966112345678');
  final _emailController = TextEditingController(text: 'info@school.edu');
  final _websiteController = TextEditingController(text: 'www.school.edu');
  final _principalController = TextEditingController(text: 'أحمد المدير');
  final _establishedController = TextEditingController(text: '2020');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'معلومات المدرسة',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveSchoolInfo)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // شعار المدرسة
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
                        onPressed: _changeSchoolLogo,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // اسم المدرسة
              CustomFormField(
                radius: 12.r,
                controller: _schoolNameController,
                title: 'اسم المدرسة',
                prefixIcon: Icon(Icons.school),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المدرسة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رقم هوية المدرسة
              CustomFormField(
                radius: 12.r,
                controller: _schoolIdController,
                title: 'رقم هوية المدرسة',
                prefixIcon: Icon(Icons.confirmation_number),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم هوية المدرسة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // العنوان
              CustomFormField(
                radius: 12.r,
                controller: _addressController,
                maxLines: 2,
                title: 'العنوان',
                prefixIcon: Icon(Icons.location_on),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان المدرسة';
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

              // البريد الإلكتروني
              CustomFormField(
                radius: 12.r,
                controller: _emailController,
                title: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email),

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

              // الموقع الإلكتروني
              CustomFormField(
                radius: 12.r,
                controller: _websiteController,
                title: 'الموقع الإلكتروني',
                prefixIcon: Icon(Icons.language),
              ),
              SizedBox(height: 16.h),

              // اسم المدير
              CustomFormField(
                radius: 12.r,
                controller: _principalController,
                title: 'اسم المدير',
                prefixIcon: Icon(Icons.person),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المدير';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // سنة التأسيس
              CustomFormField(
                radius: 12.r,
                controller: _establishedController,
                title: 'سنة التأسيس',

                prefixIcon: Icon(Icons.calendar_today),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32.h),

              CustomButton(text: 'حفظ معلومات المدرسة', onPressed: _saveSchoolInfo, radius: 12.r),
            ],
          ),
        ),
      ),
    );
  }

  void _changeSchoolLogo() {
    // TODO: تغيير شعار المدرسة
  }

  void _saveSchoolInfo() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ معلومات المدرسة بنجاح'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _schoolIdController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _principalController.dispose();
    _establishedController.dispose();
    super.dispose();
  }
}
