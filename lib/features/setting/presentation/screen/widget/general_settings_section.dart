import 'package:flutter/material.dart';
import 'package:my_template/features/setting/presentation/screen/widget/settings_tile_widget.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SettingsTileWidget(icon: Icons.lock, title: "تغيير كلمة المرور"),
          divider(),
          SettingsTileWidget(icon: Icons.language, title: "اللغة"),
          divider(),
          SettingsTileWidget(icon: Icons.notifications, title: "الإشعارات"),
        ],
      ),
    );
  }

  Widget divider() => const Divider(height: 1, color: Colors.grey, indent: 16, endIndent: 16);
}
