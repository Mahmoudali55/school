import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/execution/change_password_screen.dart';
import 'package:my_template/features/setting/presentation/execution/notifications_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/privacy_settings_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/settings_tile_widget.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTileWidget(
          icon: Icons.lock,
          title: AppLocalKay.setting_password.tr(),
          onTap: () => _navigateToChangePassword(context),
        ),

        divider(),
        SettingsTileWidget(
          icon: Icons.notifications,
          title: AppLocalKay.setting_notification.tr(),
          onTap: () => _navigateToNotificationsSettings(context),
        ),
        divider(),
        SettingsTileWidget(
          icon: Icons.privacy_tip,
          title: AppLocalKay.privacy.tr(),
          onTap: () => _navigateToPrivacySettings(context),
        ),
        divider(),
      ],
    );
  }

  Widget divider() => const Divider(height: 1, color: Colors.grey, indent: 16, endIndent: 16);

  // دوال التنقل
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  void _navigateToNotificationsSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<SettingsCubit>()..loadSettings(),
          child: NotificationsSettingsScreen(),
        ),
      ),
    );
  }

  void _navigateToPrivacySettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettingsScreen()));
  }
}
