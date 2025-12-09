// lib/features/settings/presentation/screens/notification_settings_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

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
          AppLocalKay.notification_settings.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أنواع الإشعارات
            Text(
              AppLocalKay.notification_channels.tr(),
              style: AppTextStyle.titleLarge(context, color: const Color(0xFF1F2937)),
            ),
            SizedBox(height: 16.h),

            // الإشعارات التلقائية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.notifications, color: const Color(0xFF2E5BFF)),
                title: Text(
                  AppLocalKay.push_notifications.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.push_notifications_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(
                  AppLocalKay.email_notifications.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.email_notifications_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(
                  AppLocalKay.sms_notifications.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.sms_notifications_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
              AppLocalKay.alert_types.tr(),
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
                title: Text(AppLocalKay.new_users.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.new_users_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(AppLocalKay.new_classes.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.new_classes_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(AppLocalKay.system_alerts.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.system_alerts_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(
                  AppLocalKay.emergency_alerts.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.emergency_alerts_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                title: Text(
                  AppLocalKay.system_reports.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.system_reports_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
              AppLocalKay.notification_timing.tr(),
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
                title: Text(
                  AppLocalKay.notification_hours.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.notification_hours_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                  AppLocalKay.save_notification_settings.tr(),
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
      SnackBar(
        content: Text(AppLocalKay.settings_saved_success.tr()),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _setNotificationHours() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalKay.set_notification_hours_title.tr(),
            style: AppTextStyle.titleMedium(context),
          ),
          content: Text(
            AppLocalKay.set_notification_hours_desc.tr(),
            style: AppTextStyle.bodyMedium(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalKay.settings_saved_success.tr(),
                      style: AppTextStyle.bodyMedium(context),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(AppLocalKay.save.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
          ],
        );
      },
    );
  }
}
