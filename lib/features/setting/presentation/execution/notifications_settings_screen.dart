import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.notification_settings.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;
          final cubit = context.read<SettingsCubit>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalKay.notification_control.tr(),
                    style: AppTextStyle.bodyLarge(context, color: AppColor.greyColor(context)),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildNotificationSwitch(
                          context,
                          title: AppLocalKay.general_notification.tr(),
                          value: settings.generalNotifications,
                          onChanged: (value) =>
                              cubit.toggleNotification('generalNotifications', value),
                        ),
                        _buildNotificationSwitch(
                          context,
                          title: AppLocalKay.todo_notification.tr(),
                          subtitle: AppLocalKay.new_todo_notification.tr(),
                          value: settings.assignmentAlerts,
                          onChanged: (value) => cubit.toggleNotification('assignmentAlerts', value),
                        ),
                        _buildNotificationSwitch(
                          context,
                          title: AppLocalKay.new_schedule_notification.tr(),
                          subtitle: AppLocalKay.new_schedule_notification_hint.tr(),
                          value: settings.deadlineReminders,
                          onChanged: (value) =>
                              cubit.toggleNotification('deadlineReminders', value),
                        ),
                        _buildNotificationSwitch(
                          context,
                          title: AppLocalKay.announcements.tr(),
                          value: settings.announcements,
                          onChanged: (value) => cubit.toggleNotification('announcements', value),
                        ),
                        _buildNotificationSwitch(
                          context,
                          title: AppLocalKay.email_notification.tr(),
                          value: settings.emailNotifications,
                          onChanged: (value) =>
                              cubit.toggleNotification('emailNotifications', value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    radius: 12.r,
                    text: AppLocalKay.save_settings.tr(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSwitch(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        title: Text(title, style: AppTextStyle.bodyMedium(context)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context)),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: AppColor.primaryColor(context),
      ),
    );
  }
}
