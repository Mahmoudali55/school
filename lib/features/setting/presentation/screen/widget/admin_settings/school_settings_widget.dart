import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
          title: AppLocalKay.schoolInfo.tr(),
          subtitle: AppLocalKay.schoolInfoSub.tr(),
          onTap: () => editSchoolInfo(context),
        ),
        SettingItemWidget(
          icon: Icons.group,
          title: AppLocalKay.users.tr(),
          subtitle: AppLocalKay.usersSub.tr(),
          onTap: () => manageUsers(context),
        ),
        SettingItemWidget(
          icon: Icons.class_,
          title: AppLocalKay.manageClasses.tr(),
          subtitle: AppLocalKay.classesSub.tr(),
          onTap: () => manageClasses(context),
        ),
        SettingItemWidget(
          icon: Icons.assignment,
          title: AppLocalKay.system.tr(),
          subtitle: AppLocalKay.systemSub.tr(),
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
