import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> with WidgetsBindingObserver {
  bool _isSystemGranted = true;
  bool _isFirstCheck = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkSystemPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Add a 500ms delay to allow the OS to update its permission registry before querying
      Future.delayed(const Duration(milliseconds: 500), () {
        _checkSystemPermission();
      });
    }
  }

  Future<void> _checkSystemPermission() async {
    final status = await Permission.notification.status;
    final isGranted = status.isGranted;

    if (mounted) {
      // If system permissions were previously false/denied, and are now granted,
      // automatically turn on general notifications inside the Cubit.
      if (!_isFirstCheck && !_isSystemGranted && isGranted) {
        final cubit = context.read<SettingsCubit>();
        cubit.toggleNotification('generalNotifications', true);
      }
      
      setState(() {
        _isSystemGranted = isGranted;
        _isFirstCheck = false;
      });
    }
  }

  Future<void> _handleMasterToggle(bool newValue, SettingsCubit cubit) async {
    if (newValue) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        setState(() {
          _isSystemGranted = true;
        });
        cubit.toggleNotification('generalNotifications', true);
      } else if (status.isDenied) {
        final requestStatus = await Permission.notification.request();
        if (requestStatus.isGranted) {
          setState(() {
            _isSystemGranted = true;
          });
          cubit.toggleNotification('generalNotifications', true);
        } else {
          setState(() {
            _isSystemGranted = false;
          });
          cubit.toggleNotification('generalNotifications', false);
        }
      } else {
        setState(() {
          _isSystemGranted = false;
        });
        _showPermissionDialog(context);
      }
    } else {
      cubit.toggleNotification('generalNotifications', false);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          backgroundColor: AppColor.surfaceColor(context),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_off_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const Gap(20),
                Text(
                  "تفعيل التنبيهات",
                  style: AppTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  "تنبيهات النظام معطلة حالياً لهاتفك. يرجى تفعيل الصلاحية من إعدادات الجهاز لتتمكن من تشغيل الإشعارات داخل التطبيق.",
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    color: AppColor.textColor(context).withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          "إلغاء",
                          style: AppTextStyle.bodyLarge(context).copyWith(
                            color: AppColor.textColor(context).withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: CustomButton(
                        height: 44.h,
                        radius: 12.r,
                        text: "الإعدادات",
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primaryColor(context),
                            AppColor.primaryColor(context).withOpacity(0.85),
                          ],
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await openAppSettings();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.notification_settings.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.textColor(context)),
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
          final isMasterActive = settings.generalNotifications && _isSystemGranted;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    children: [
                      // Visual Header Card
                      _buildHeaderCard(context),
                      const Gap(24),

                      // System Permission Alert Banner
                      if (!_isSystemGranted) ...[
                        GestureDetector(
                          onTap: () => _showPermissionDialog(context),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.amber.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "إشعارات الجهاز غير مفعلة",
                                        style: AppTextStyle.bodyMedium(context).copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade900,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        "اضغط هنا لتفعيل التنبيهات من إعدادات النظام وتلقي الإشعارات.",
                                        style: AppTextStyle.bodySmall(context).copyWith(
                                          color: Colors.amber.shade900.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.amber.shade900, size: 14),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                      
                      // Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          AppLocalKay.notification_control.tr(),
                          style: AppTextStyle.titleSmall(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor(context).withOpacity(0.6),
                          ),
                        ),
                      ),
                      const Gap(10),

                      // Cohesive Grouped Settings Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.surfaceColor(context),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColor.borderColor(context), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.shadowColor(context).withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingItem(
                              context,
                              icon: Icons.notifications_active_rounded,
                              iconBgColor: Colors.blue.withOpacity(0.1),
                              iconColor: Colors.blue,
                              title: AppLocalKay.general_notification.tr(),
                              subtitle: "تفعيل أو تعطيل الإشعارات العامة داخل التطبيق",
                              value: isMasterActive,
                              onChanged: (value) => _handleMasterToggle(value, cubit),
                              showDivider: true,
                            ),
                            _buildSettingItem(
                              context,
                              icon: Icons.assignment_turned_in_rounded,
                              iconBgColor: Colors.amber.withOpacity(0.1),
                              iconColor: Colors.amber.shade700,
                              title: AppLocalKay.todo_notification.tr(),
                              subtitle: AppLocalKay.new_todo_notification.tr(),
                              value: isMasterActive ? settings.assignmentAlerts : false,
                              onChanged: isMasterActive
                                  ? (value) => cubit.toggleNotification('assignmentAlerts', value)
                                  : null,
                              showDivider: true,
                              isEnabled: isMasterActive,
                            ),
                            _buildSettingItem(
                              context,
                              icon: Icons.alarm_on_rounded,
                              iconBgColor: Colors.red.withOpacity(0.1),
                              iconColor: Colors.red,
                              title: AppLocalKay.new_schedule_notification.tr(),
                              subtitle: AppLocalKay.new_schedule_notification_hint.tr(),
                              value: isMasterActive ? settings.deadlineReminders : false,
                              onChanged: isMasterActive
                                  ? (value) => cubit.toggleNotification('deadlineReminders', value)
                                  : null,
                              showDivider: true,
                              isEnabled: isMasterActive,
                            ),
                            _buildSettingItem(
                              context,
                              icon: Icons.campaign_rounded,
                              iconBgColor: Colors.green.withOpacity(0.1),
                              iconColor: Colors.green,
                              title: AppLocalKay.announcements.tr(),
                              subtitle: "متابعة الإعلانات والأخبار المدرسية الهامة",
                              value: isMasterActive ? settings.announcements : false,
                              onChanged: isMasterActive
                                  ? (value) => cubit.toggleNotification('announcements', value)
                                  : null,
                              showDivider: true,
                              isEnabled: isMasterActive,
                            ),
                            _buildSettingItem(
                              context,
                              icon: Icons.alternate_email_rounded,
                              iconBgColor: Colors.purple.withOpacity(0.1),
                              iconColor: Colors.purple,
                              title: AppLocalKay.email_notification.tr(),
                              subtitle: "تلقي ملخصات وتقارير دورية عبر البريد الإلكتروني",
                              value: isMasterActive ? settings.emailNotifications : false,
                              onChanged: isMasterActive
                                  ? (value) => cubit.toggleNotification('emailNotifications', value)
                                  : null,
                              showDivider: false,
                              isEnabled: isMasterActive,
                            ),
                          ],
                        ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ),
                
                // Save Button at the Bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    radius: 16.r,
                    text: AppLocalKay.save_settings.tr(),
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor(context),
                        AppColor.primaryColor(context).withOpacity(0.85),
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context),
            AppColor.primaryColor(context).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor(context).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ابقَ على اطلاع دائم",
                  style: AppTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Gap(6),
                Text(
                  "اختر التنبيهات التي ترغب في تلقيها عبر هاتفك أو بريدك الإلكتروني للتحكم التام في إشعاراتك.",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required bool showDivider,
    bool isEnabled = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.45,
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 22.r),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(3),
                      Text(
                        subtitle,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: AppColor.textColor(context).withOpacity(0.55),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColor.primaryColor(context),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.8,
            color: AppColor.dividerColor(context).withOpacity(0.6),
            indent: 74.r,
            endIndent: 16.r,
          ),
      ],
    );
  }
}
