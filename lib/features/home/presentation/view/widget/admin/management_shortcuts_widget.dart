import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      title: "إدارة المستخدمين",
      description: "طلاب ومعلمين",
      icon: Icons.people,
      color: Colors.blue,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen())),
    ),
    ManagementShortcut(
      title: "إدارة الفصول",
      description: "الجداول والمناهج",
      icon: Icons.class_,
      color: Colors.green,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagementScreen())),
    ),
    ManagementShortcut(
      title: "التقارير",
      description: "والإحصائيات",
      icon: Icons.analytics,
      color: Colors.orange,
      onTap: (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage())),
    ),
    ManagementShortcut(
      title: "إدارة النقل",
      description: "الحافلات",
      icon: Icons.directions_bus,
      color: Colors.purple,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransportManagementScreen()),
      ),
    ),
    ManagementShortcut(
      title: "الإعدادات المالية",
      description: "الرسوم والمصروفات",
      icon: Icons.payments,
      color: Colors.pink,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FinancialSettingsScreen()),
      ),
    ),
    ManagementShortcut(
      title: "الإعدادات",
      description: "عامة",
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
          "روابط سريعة للإدارة",
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
