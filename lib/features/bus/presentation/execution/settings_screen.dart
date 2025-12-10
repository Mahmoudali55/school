import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class BusSettingsPage extends StatefulWidget {
  const BusSettingsPage({super.key});

  @override
  State<BusSettingsPage> createState() => _BusSettingsPageState();
}

class _BusSettingsPageState extends State<BusSettingsPage> {
  bool busNotifications = true;
  bool studentNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: BasePageWidget(
        title: AppLocalKay.settings.tr(),
        isScrollable: false,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildCardOption(
                icon: Icons.directions_bus,
                title: AppLocalKay.notifications_bus.tr(),
                subtitle: AppLocalKay.notifications_bus_content.tr(),
                isSwitch: true,
                switchValue: busNotifications,
                onSwitchChanged: (val) => setState(() => busNotifications = val),
              ),
              SizedBox(height: 16.h),
              _buildCardOption(
                icon: Icons.notifications_active,
                title: AppLocalKay.notifications_student.tr(),
                subtitle: AppLocalKay.notifications_student_content.tr(),
                isSwitch: true,
                switchValue: studentNotifications,
                onSwitchChanged: (val) => setState(() => studentNotifications = val),
              ),
              SizedBox(height: 16.h),
              _buildCardOption(
                icon: Icons.person,
                title: AppLocalKay.driver_info.tr(),
                subtitle: AppLocalKay.driver_info_content.tr(),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardOption({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 3,
      shadowColor: Colors.grey.shade300,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              )
            : null,
        trailing: isSwitch
            ? Switch(value: switchValue, onChanged: onSwitchChanged, activeColor: Colors.orange)
            : (!isSwitch ? Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey) : null),
        onTap: !isSwitch ? onTap : null,
      ),
    );
  }
}
