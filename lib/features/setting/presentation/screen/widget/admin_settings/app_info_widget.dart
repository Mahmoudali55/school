import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/setting/presentation/execution/help_center_screen.dart';
import 'package:my_template/features/setting/presentation/execution/privacy_policy_screen.dart';
import 'package:my_template/features/setting/presentation/execution/terms_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/setting_item_widget.dart';

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.help,
          title: 'مركز المساعدة',
          subtitle: 'الدعم والأسئلة الشائعة',
          onTap: () => showHelpCenter(context),
        ),
        SettingItemWidget(
          icon: Icons.privacy_tip,
          title: 'الخصوصية',
          subtitle: 'سياسة الخصوصية',
          onTap: () => showPrivacyPolicy(context),
        ),
        SettingItemWidget(
          icon: Icons.description,
          title: 'الشروط والأحكام',
          subtitle: 'شروط استخدام التطبيق',
          onTap: () => showTerms(context),
        ),
        SettingItemWidget(
          icon: Icons.info,
          title: 'حول التطبيق',
          subtitle: 'الإصدار والمعلومات',
          onTap: () => showAbout(context),
        ),
      ],
    );
  }

  showHelpCenter(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterScreen()));
  }

  showPrivacyPolicy(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
  }

  showTerms(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsScreen()));
  }

  showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'نظام إدارة المدرسة',
      applicationVersion: 'الإصدار 2.1.0',
      applicationIcon: Icon(Icons.school, size: 50.w),
    );
  }
}
