import 'package:flutter/material.dart';
import 'package:my_template/features/setting/presentation/execution/class_management_screen.dart';
import 'package:my_template/features/setting/presentation/execution/school_info_screen.dart';
import 'package:my_template/features/setting/presentation/execution/system_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/user_management_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/setting_item_widget.dart';

class SchoolSettingsWidget extends StatelessWidget {
  const SchoolSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.school,
          title: 'معلومات المدرسة',
          subtitle: 'تعديل بيانات المدرسة',
          onTap: () => editSchoolInfo(context),
        ),
        SettingItemWidget(
          icon: Icons.group,
          title: 'إدارة المستخدمين',
          subtitle: 'إضافة وحذف المستخدمين',
          onTap: () => manageUsers(context),
        ),
        SettingItemWidget(
          icon: Icons.class_,
          title: 'إدارة الصفوف',
          subtitle: 'تنظيم الصفوف والشعب',
          onTap: () => manageClasses(context),
        ),
        SettingItemWidget(
          icon: Icons.assignment,
          title: 'إعدادات النظام',
          subtitle: 'إعدادات الدرجات والتقارير',
          onTap: () => systemSettings(context),
        ),
      ],
    );
  }

  editSchoolInfo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolInfoScreen()));
  }

  manageUsers(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen()));
  }

  manageClasses(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagementScreen()));
  }

  systemSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SystemSettingsScreen()));
  }
}
