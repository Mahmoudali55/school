import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/execution/change_password_screen.dart';
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
          icon: Icons.lock,
          title: AppLocalKay.setting_password.tr(),
          subtitle: AppLocalKay.setting_password_change.tr(),
          onTap: () => changePassword(context),
        ),

        SettingItemWidget(
          icon: Icons.notifications,
          title: AppLocalKay.setting_notification.tr(),
          subtitle: AppLocalKay.setting_notification_alert.tr(),
          onTap: () => notificationSettings(context),
        ),
      ],
    );
  }

  changePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(value: sl<SettingsCubit>(), child: ChangePasswordScreen()),
      ),
    );
  }

  securitySettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SecuritySettingsScreen()));
  }

  notificationSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
  }
}
