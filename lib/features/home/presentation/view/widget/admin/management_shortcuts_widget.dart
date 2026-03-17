import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/view/execution/financial_settings_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/transport_management_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/shortcut_card_widget.dart';

class ManagementShortcuts extends StatelessWidget {
  final List<ManagementShortcut> shortcuts = [
    // ManagementShortcut(
    //   title: AppLocalKay.reports_title.tr(),
    //   description: AppLocalKay.reports_desc.tr(),
    //   icon: Icons.analytics,
    //   color: Colors.orange,
    //   onTap: (context) =>
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage())),
    // ),
    ManagementShortcut(
      title: AppLocalKay.transport_title.tr(),
      description: AppLocalKay.transport_desc.tr(),
      icon: Icons.directions_bus,
      color: Colors.purple,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<HomeCubit>()..getData(),
            child: TransportManagementScreen(),
          ),
        ),
      ),
    ),
    ManagementShortcut(
      title: AppLocalKay.financial_title.tr(),
      description: AppLocalKay.financial_desc.tr(),
      icon: Icons.payments,
      color: Colors.pink,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const FinancialSettingsScreen(),
          ),
        ),
      ),
    ),

    ManagementShortcut(
      title: AppLocalKay.school_uniform.tr(),
      description: AppLocalKay.uniform_orders.tr(),
      icon: Icons.checkroom,
      color: Colors.teal,
      onTap: (context) => Navigator.pushNamed(context, RoutesName.uniformAdminScreen),
    ),
    ManagementShortcut(
      title: AppLocalKay.student_leave.tr(),
      description: AppLocalKay.leave_requests.tr(),
      icon: Icons.exit_to_app,
      color: Colors.indigo,
      onTap: (context) => Navigator.pushNamed(context, RoutesName.leaveAdminScreen),
    ),

    ManagementShortcut(
      title: AppLocalKay.teachers_ar.tr(),
      description: AppLocalKay.teachers_ar.tr(),
      icon: Icons.label_important,
      color: Colors.deepOrange,
      onTap: (context) => Navigator.pushNamed(context, RoutesName.teacherScreen),
    ),
    ManagementShortcut(
      title: AppLocalKay.ai_generation.tr(),
      description: AppLocalKay.generate_schedule.tr(),
      icon: Icons.auto_awesome,
      color: Colors.blueAccent,
      onTap: (context) => Navigator.pushNamed(context, RoutesName.adminScheduleGeneratorScreen),
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
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140.w,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: .85,
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
