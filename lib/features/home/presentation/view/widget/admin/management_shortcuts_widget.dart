import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';
import 'package:my_template/features/home/presentation/view/execution/class_management_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/financial_settings_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/reports_page.dart';
import 'package:my_template/features/home/presentation/view/execution/settings_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/transport_management_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/user_management_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/shortcut_card_widget.dart';

class ManagementShortcuts extends StatelessWidget {
  final List<ManagementShortcut> shortcuts = [
    ManagementShortcut(
      title: AppLocalKay.user_management_title.tr(),
      description: AppLocalKay.user_management_desc.tr(),
      icon: Icons.people,
      color: Colors.blue,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen())),
    ),
    ManagementShortcut(
      title: AppLocalKay.class_management_title.tr(),
      description: AppLocalKay.class_management_desc.tr(),
      icon: Icons.class_,
      color: Colors.green,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagementScreen())),
    ),
    ManagementShortcut(
      title: AppLocalKay.reports_title.tr(),
      description: AppLocalKay.reports_desc.tr(),
      icon: Icons.analytics,
      color: Colors.orange,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage())),
    ),
    ManagementShortcut(
      title: AppLocalKay.transport_title.tr(),
      description: AppLocalKay.transport_desc.tr(),
      icon: Icons.directions_bus,
      color: Colors.purple,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransportManagementScreen()),
      ),
    ),
    ManagementShortcut(
      title: AppLocalKay.financial_title.tr(),
      description: AppLocalKay.financial_desc.tr(),
      icon: Icons.payments,
      color: Colors.pink,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FinancialSettingsScreen()),
      ),
    ),
    ManagementShortcut(
      title: AppLocalKay.settings_title.tr(),
      description: AppLocalKay.settings_desc.tr(),
      icon: Icons.settings,
      color: Colors.grey,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen())),
    ),
  ];

  ManagementShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quickLinks.tr(),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140.w,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1,
          ),
          itemCount: shortcuts.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => shortcuts[index].onTap?.call(context),
            child: ShortcutCard(shortcut: shortcuts[index]),
          ),
        ),
      ],
    );
  }
}
