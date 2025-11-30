import 'package:flutter/material.dart';
import 'package:my_template/features/setting/presentation/execution/change_password_screen.dart';
import 'package:my_template/features/setting/presentation/execution/edit_profile_screen.dart';
import 'package:my_template/features/setting/presentation/execution/notification_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/security_settings_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/setting_item_widget.dart';

class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.person,
          title: 'الملف الشخصي',
          subtitle: 'تعديل المعلومات الشخصية',
          onTap: () => editProfile(context),
        ),
        SettingItemWidget(
          icon: Icons.lock,
          title: 'كلمة المرور',
          subtitle: 'تغيير كلمة المرور',
          onTap: () => changePassword(context),
        ),
        SettingItemWidget(
          icon: Icons.security,
          title: 'الأمان',
          subtitle: 'المصادقة الثنائية والإعدادات الأمنية',
          onTap: () => securitySettings(context),
        ),
        SettingItemWidget(
          icon: Icons.notifications,
          title: 'الإشعارات',
          subtitle: 'إدارة الإشعارات والتنبيهات',
          onTap: () => notificationSettings(context),
        ),
      ],
    );
  }

  editProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }

  changePassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  securitySettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SecuritySettingsScreen()));
  }

  notificationSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
  }
}
