// lib/features/settings/presentation/screens/security_settings_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.security_settings.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المصادقة الثنائية
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.security, color: AppColor.primaryColor(context)),
                title: Text(
                  AppLocalKay.two_factor_auth.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.two_factor_auth_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                secondary: Icon(Icons.fingerprint, color: AppColor.primaryColor(context)),
                title: Text(
                  AppLocalKay.biometric_auth.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.biometric_auth_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                secondary: Icon(Icons.timer, color: AppColor.primaryColor(context)),
                title: Text(AppLocalKay.auto_logout.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.auto_logout_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                  leading: Icon(Icons.access_time, color: AppColor.primaryColor(context)),
                  title: Text(
                    AppLocalKay.session_timeout.tr(),
                    style: AppTextStyle.bodyLarge(context),
                  ),
                  subtitle: Text(
                    '${_sessionTimeout} ${AppLocalKay.minutes.tr()}',
                    style: AppTextStyle.bodySmall(context),
                  ),
                  trailing: DropdownButton<int>(
                    value: _sessionTimeout,
                    items: [15, 30, 60, 120]
                        .map(
                          (int value) => DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value ${AppLocalKay.minutes.tr()}'),
                          ),
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
                secondary: Icon(Icons.warning, color: AppColor.primaryColor(context)),
                title: Text(AppLocalKay.login_alerts.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.login_alerts_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
                secondary: Icon(Icons.devices, color: AppColor.primaryColor(context)),
                title: Text(
                  AppLocalKay.device_management.tr(),
                  style: AppTextStyle.bodyLarge(context),
                ),
                subtitle: Text(
                  AppLocalKay.device_management_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
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
              AppLocalKay.login_history.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),
            Card(
              child: ListTile(
                leading: Icon(Icons.history, color: AppColor.primaryColor(context)),
                title: Text(AppLocalKay.login_history.tr(), style: AppTextStyle.bodyLarge(context)),
                subtitle: Text(
                  AppLocalKay.login_history_sub.tr(),
                  style: AppTextStyle.bodySmall(context),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                onTap: _showLoginHistory,
              ),
            ),
            SizedBox(height: 32.h),

            // زر الحفظ
            CustomButton(
              text: AppLocalKay.save_security_settings.tr(),
              onPressed: _saveSecuritySettings,
              radius: 12,
            ),
          ],
        ),
      ),
    );
  }

  void _saveSecuritySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalKay.settings_saved_success.tr()),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _showLoginHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHistoryScreen()));
  }
}
