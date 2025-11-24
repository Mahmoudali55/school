import 'package:flutter/material.dart';
import 'package:my_template/features/setting/presentation/screen/widget/settings_tile_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SettingsTileWidget(icon: Icons.help_outline, title: "مساعدة"),
          divider(),
          SettingsTileWidget(icon: Icons.support_agent, title: "اتصل بالدعم"),
        ],
      ),
    );
  }

  Widget divider() => const Divider(height: 1, color: Colors.grey, indent: 16, endIndent: 16);
}
