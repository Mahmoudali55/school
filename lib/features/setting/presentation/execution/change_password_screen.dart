// lib/features/settings/presentation/screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(
        title: Text(
          'تغيير كلمة المرور',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // كلمة المرور الحالية
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrentPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور الحالية';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // كلمة المرور الجديدة
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور الجديدة';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // تأكيد كلمة المرور
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى تأكيد كلمة المرور';
                  }
                  if (value != _newPasswordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // نصائح الأمان
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نصائح لأمان أفضل:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• استخدم مزيج من الأحرف والأرقام والرموز\n'
                        '• تجنب استخدام كلمات مرور سهلة التخمين\n'
                        '• غير كلمة المرور بشكل دوري',
                        style: TextStyle(fontSize: 12.sp, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // زر تغيير كلمة المرور
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'تغيير كلمة المرور',
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
