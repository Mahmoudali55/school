import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    bool _notificationsEnabled = true;
    bool _darkModeEnabled = false;
    bool _biometricEnabled = false;
    String _selectedLanguage = 'العربية';
    String _selectedTheme = 'فاتح';
    return Column(
      children: [
        // اللغة
        Card(
          child: ListTile(
            leading: Icon(Icons.language, color: AppColor.primaryColor(context)),
            title: Text('اللغة'),
            subtitle: Text(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: ['العربية', 'English', 'Français']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              underline: SizedBox(),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // المظهر
        Card(
          child: ListTile(
            leading: Icon(Icons.palette, color: AppColor.primaryColor(context)),
            title: Text('المظهر'),
            subtitle: Text(_selectedTheme),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: ['فاتح', 'غامق', 'تلقائي']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
              underline: SizedBox(),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // الإشعارات
        Card(
          child: SwitchListTile(
            secondary: Icon(Icons.notifications_active, color: AppColor.primaryColor(context)),
            title: Text('الإشعارات'),
            subtitle: Text('تفعيل/تعطيل الإشعارات'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ),
        SizedBox(height: 8.h),

        // المصادقة البيومترية
        Card(
          child: SwitchListTile(
            secondary: Icon(Icons.fingerprint, color: AppColor.primaryColor(context)),
            title: Text('المصادقة البيومترية'),
            subtitle: Text('استخدام البصمة أو التعرف على الوجه'),
            value: _biometricEnabled,
            onChanged: (bool value) {
              setState(() {
                _biometricEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
