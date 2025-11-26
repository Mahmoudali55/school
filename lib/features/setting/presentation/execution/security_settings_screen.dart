// lib/features/settings/presentation/screens/security_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/setting/presentation/execution/login_history_screen.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactorAuth = true;
  bool _biometricAuth = false;
  bool _autoLogout = true;
  int _sessionTimeout = 30;
  bool _loginAlerts = true;
  bool _deviceManagement = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات الأمنية',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveSecuritySettings)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المصادقة الثنائية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.security, color: const Color(0xFF2E5BFF)),
                title: Text('المصادقة الثنائية'),
                subtitle: Text('تفعيل المصادقة الثنائية لتسجيل الدخول'),
                value: _twoFactorAuth,
                onChanged: (bool value) {
                  setState(() {
                    _twoFactorAuth = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // المصادقة البيومترية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.fingerprint, color: const Color(0xFF2E5BFF)),
                title: Text('المصادقة البيومترية'),
                subtitle: Text('استخدام البصمة أو التعرف على الوجه'),
                value: _biometricAuth,
                onChanged: (bool value) {
                  setState(() {
                    _biometricAuth = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // تسجيل الخروج التلقائي
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.timer, color: const Color(0xFF2E5BFF)),
                title: Text('تسجيل الخروج التلقائي'),
                subtitle: Text('تسجيل الخروج بعد فترة من عدم النشاط'),
                value: _autoLogout,
                onChanged: (bool value) {
                  setState(() {
                    _autoLogout = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // مهلة الجلسة
            if (_autoLogout) ...[
              Card(
                child: ListTile(
                  leading: Icon(Icons.access_time, color: const Color(0xFF2E5BFF)),
                  title: Text('مهلة الجلسة'),
                  subtitle: Text('${_sessionTimeout} دقيقة'),
                  trailing: DropdownButton<int>(
                    value: _sessionTimeout,
                    items: [15, 30, 60, 120]
                        .map(
                          (int value) =>
                              DropdownMenuItem<int>(value: value, child: Text('$value دقيقة')),
                        )
                        .toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _sessionTimeout = newValue!;
                      });
                    },
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],

            // تنبيهات تسجيل الدخول
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.warning, color: const Color(0xFF2E5BFF)),
                title: Text('تنبيهات تسجيل الدخول'),
                subtitle: Text('إرسال تنبيه عند تسجيل الدخول من جهاز جديد'),
                value: _loginAlerts,
                onChanged: (bool value) {
                  setState(() {
                    _loginAlerts = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // إدارة الأجهزة
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.devices, color: const Color(0xFF2E5BFF)),
                title: Text('إدارة الأجهزة'),
                subtitle: Text('عرض وإدارة الأجهزة المتصلة بالحساب'),
                value: _deviceManagement,
                onChanged: (bool value) {
                  setState(() {
                    _deviceManagement = value;
                  });
                },
              ),
            ),
            SizedBox(height: 24.h),

            // سجل الأمان
            Text(
              'سجل الأمان',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),
            Card(
              child: ListTile(
                leading: Icon(Icons.history, color: const Color(0xFF2E5BFF)),
                title: Text('عرض سجل الدخول'),
                subtitle: Text('عرض جميع محاولات الدخول إلى الحساب'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                onTap: _showLoginHistory,
              ),
            ),
            SizedBox(height: 32.h),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _saveSecuritySettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'حفظ الإعدادات الأمنية',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSecuritySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ الإعدادات الأمنية بنجاح'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  void _showLoginHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHistoryScreen()));
  }
}
