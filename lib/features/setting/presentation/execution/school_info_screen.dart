// lib/features/settings/presentation/screens/school_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(
        title: Text(
          'معلومات المدرسة',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                    backgroundColor: const Color(0xFF2E5BFF).withOpacity(0.1),
                    child: Icon(Icons.school, size: 50.w, color: const Color(0xFF2E5BFF)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: const Color(0xFF2E5BFF),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 12.w, color: Colors.white),
                        onPressed: _changeSchoolLogo,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // اسم المدرسة
              TextFormField(
                controller: _schoolNameController,
                decoration: InputDecoration(
                  labelText: 'اسم المدرسة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المدرسة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رقم هوية المدرسة
              TextFormField(
                controller: _schoolIdController,
                decoration: InputDecoration(
                  labelText: 'رقم هوية المدرسة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم هوية المدرسة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // العنوان
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان المدرسة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رقم الهاتف
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // البريد الإلكتروني
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.email),
                ),
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
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'الموقع الإلكتروني',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.language),
                ),
              ),
              SizedBox(height: 16.h),

              // اسم المدير
              TextFormField(
                controller: _principalController,
                decoration: InputDecoration(
                  labelText: 'اسم المدير',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المدير';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // سنة التأسيس
              TextFormField(
                controller: _establishedController,
                decoration: InputDecoration(
                  labelText: 'سنة التأسيس',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32.h),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _saveSchoolInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'حفظ معلومات المدرسة',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
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
