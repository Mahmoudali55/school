import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _generalNotifications = true;
  bool _assignmentAlerts = true;
  bool _deadlineReminders = true;
  bool _announcements = true;
  bool _emailNotifications = false;

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
      body: Padding(
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
                      title: AppLocalKay.general_notification.tr(),
                      value: _generalNotifications,
                      onChanged: (value) => setState(() => _generalNotifications = value),
                    ),
                    _buildNotificationSwitch(
                      title: AppLocalKay.todo_notification.tr(),
                      subtitle: AppLocalKay.new_todo_notification.tr(),
                      value: _assignmentAlerts,
                      onChanged: (value) => setState(() => _assignmentAlerts = value),
                    ),
                    _buildNotificationSwitch(
                      title: AppLocalKay.new_schedule_notification.tr(),
                      subtitle: AppLocalKay.new_schedule_notification_hint.tr(),
                      value: _deadlineReminders,
                      onChanged: (value) => setState(() => _deadlineReminders = value),
                    ),
                    _buildNotificationSwitch(
                      title: AppLocalKay.announcements.tr(),
                      value: _announcements,
                      onChanged: (value) => setState(() => _announcements = value),
                    ),
                    _buildNotificationSwitch(
                      title: AppLocalKay.email_notification.tr(),
                      value: _emailNotifications,
                      onChanged: (value) => setState(() => _emailNotifications = value),
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
      ),
    );
  }

  Widget _buildNotificationSwitch({
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
