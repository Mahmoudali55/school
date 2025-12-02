import 'package:flutter/material.dart';
import 'package:my_template/features/setting/presentation/execution/change_password_screen.dart';
import 'package:my_template/features/setting/presentation/execution/language_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/notifications_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/privacy_settings_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/settings_tile_widget.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SettingsTileWidget(
            icon: Icons.lock,
            title: "تغيير كلمة المرور",
            onTap: () => _navigateToChangePassword(context),
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.language,
            title: "اللغة",
            onTap: () => _navigateToLanguageSettings(context),
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.notifications,
            title: "الإشعارات",
            onTap: () => _navigateToNotificationsSettings(context),
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.privacy_tip,
            title: "الخصوصية",
            onTap: () => _navigateToPrivacySettings(context),
          ),
        ],
      ),
    );
  }

  Widget divider() => const Divider(height: 1, color: Colors.grey, indent: 16, endIndent: 16);

  // دوال التنقل
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  void _navigateToLanguageSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsScreen()));
  }

  void _navigateToNotificationsSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsSettingsScreen()));
  }

  void _navigateToPrivacySettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettingsScreen()));
  }
}
