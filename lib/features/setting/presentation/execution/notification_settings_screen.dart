// lib/features/settings/presentation/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _newUserNotifications = true;
  bool _newClassNotifications = true;
  bool _systemAlerts = true;
  bool _emergencyAlerts = true;
  bool _reportNotifications = true;

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
          'إعدادات الإشعارات',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveNotificationSettings)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أنواع الإشعارات
            Text(
              'قنوات الإشعارات',
              style: AppTextStyle.titleLarge(context, color: const Color(0xFF1F2937)),
            ),
            SizedBox(height: 16.h),

            // الإشعارات التلقائية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.notifications, color: const Color(0xFF2E5BFF)),
                title: Text('الإشعارات التلقائية'),
                subtitle: Text('استقبال الإشعارات داخل التطبيق'),
                value: _pushNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // الإشعارات البريدية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.email, color: const Color(0xFF2E5BFF)),
                title: Text('الإشعارات البريدية'),
                subtitle: Text('إرسال إشعارات عبر البريد الإلكتروني'),
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // إشعارات SMS
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.sms, color: const Color(0xFF2E5BFF)),
                title: Text('إشعارات SMS'),
                subtitle: Text('إرسال إشعارات عبر الرسائل النصية'),
                value: _smsNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 24.h),

            // أنواع التنبيهات
            Text(
              'أنواع التنبيهات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),

            // مستخدمين جدد
            Card(
              child: SwitchListTile(
                title: Text('مستخدمين جدد'),
                subtitle: Text('استقبال إشعارات عند إضافة مستخدم جديد'),
                value: _newUserNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _newUserNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // صفوف جديدة
            Card(
              child: SwitchListTile(
                title: Text('صفوف جديدة'),
                subtitle: Text('استقبال إشعارات عند إضافة صف جديد'),
                value: _newClassNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _newClassNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // تنبيهات النظام
            Card(
              child: SwitchListTile(
                title: Text('تنبيهات النظام'),
                subtitle: Text('استقبال إشعارات حول تحديثات النظام'),
                value: _systemAlerts,
                onChanged: (bool value) {
                  setState(() {
                    _systemAlerts = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // تنبيهات الطوارئ
            Card(
              child: SwitchListTile(
                title: Text('تنبيهات الطوارئ'),
                subtitle: Text('إشعارات مهمة تتطلب تدخل فوري'),
                value: _emergencyAlerts,
                onChanged: (bool value) {
                  setState(() {
                    _emergencyAlerts = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // تقارير النظام
            Card(
              child: SwitchListTile(
                title: Text('تقارير النظام'),
                subtitle: Text('استقبال التقارير الدورية للنظام'),
                value: _reportNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _reportNotifications = value;
                  });
                },
              ),
            ),
            SizedBox(height: 32.h),

            // توقيت الإشعارات
            Text(
              'توقيت الإشعارات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),
            Card(
              child: ListTile(
                leading: Icon(Icons.access_time, color: const Color(0xFF2E5BFF)),
                title: Text('ساعات الإشعارات'),
                subtitle: Text('من ٨ صباحاً إلى ٨ مساءً'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                onTap: _setNotificationHours,
              ),
            ),
            SizedBox(height: 32.h),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _saveNotificationSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'حفظ إعدادات الإشعارات',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ إعدادات الإشعارات بنجاح'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  void _setNotificationHours() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ساعات الإشعارات'),
          content: Text('تحديد الأوقات المسموح بها لإرسال الإشعارات'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تحديث ساعات الإشعارات'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}
