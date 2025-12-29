import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.settings_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Profile Section
          _buildProfileSection(context),
          SizedBox(height: 20.h),
          // Settings Sections
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 30.w, color: Colors.blue),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مدير المدرسة',
                    style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'أ. أحمد محمد',
                    style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'admin@school.edu.sa',
                    style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Edit profile
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildSettingsCategory(context, 'إعدادات المدرسة', Icons.school, [
          _buildSettingsItem('معلومات المدرسة', Icons.info, () {}),
          _buildSettingsItem('الشعار والهوية', Icons.color_lens, () {}),
          _buildSettingsItem('الفصول الدراسية', Icons.class_, () {}),
          _buildSettingsItem('الجدول الدراسي', Icons.schedule, () {}),
        ]),
        SizedBox(height: 20.h),
        _buildSettingsCategory(context, 'إعدادات النظام', Icons.settings, [
          _buildSettingsItem('الإشعارات', Icons.notifications, () {}),
          _buildSettingsItem('الخصوصية', Icons.security, () {}),
          _buildSettingsItem('النسخ الاحتياطي', Icons.backup, () {}),
          _buildSettingsItem('تحديث النظام', Icons.update, () {}),
        ]),
        SizedBox(height: 20.h),
        _buildSettingsCategory(context, 'الدعم', Icons.help, [
          _buildSettingsItem('المساعدة', Icons.help_center, () {}),
          _buildSettingsItem('اتصل بنا', Icons.contact_support, () {}),
          _buildSettingsItem('شروط الاستخدام', Icons.description, () {}),
          _buildSettingsItem('سياسة الخصوصية', Icons.privacy_tip, () {}),
        ]),
        SizedBox(height: 20.h),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildSettingsCategory(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> items,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 20.w),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Column(children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20.w, color: Colors.grey.shade600),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red, size: 20.w),
        title: Text(
          'تسجيل الخروج',
          style: AppTextStyle.bodyMedium(
            context,
          ).copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Logout
        },
      ),
    );
  }
}
