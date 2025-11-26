// lib/features/settings/presentation/widgets/setting_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? const Color(0xFF2E5BFF), size: 24.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
