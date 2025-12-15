import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
