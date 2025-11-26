// lib/features/settings/presentation/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(
        title: Text(
          'تعديل الملف الشخصي',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                        onPressed: _changeProfilePicture,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // الاسم الكامل
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الكامل';
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

              // المنصب
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: 'المنصب',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المنصب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'حفظ التغييرات',
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
