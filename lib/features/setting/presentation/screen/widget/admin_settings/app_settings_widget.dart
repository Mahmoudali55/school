import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    bool _notificationsEnabled = true;

    bool _biometricEnabled = false;

    String _selectedTheme = AppLocalKay.light.tr();
    return Column(
      children: [
        // اللغة
        SizedBox(height: 8.h),

        // المظهر
        Card(
          child: ListTile(
            leading: Icon(Icons.palette, color: AppColor.primaryColor(context)),
            title: Text(AppLocalKay.theme.tr(), style: AppTextStyle.bodyLarge(context)),
            subtitle: Text(_selectedTheme),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: [AppLocalKay.light.tr(), AppLocalKay.dark.tr(), AppLocalKay.system_theme.tr()]
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
            title: Text(AppLocalKay.notification.tr()),
            subtitle: Text(
              AppLocalKay.notificationsSub.tr(),
              style: AppTextStyle.bodyLarge(context),
            ),
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
            title: Text(AppLocalKay.biometric.tr(), style: AppTextStyle.bodyLarge(context)),
            subtitle: Text(AppLocalKay.biometricSub.tr(), style: AppTextStyle.bodyMedium(context)),
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
