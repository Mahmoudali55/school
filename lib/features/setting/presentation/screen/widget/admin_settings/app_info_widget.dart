import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
          title: AppLocalKay.helpCenter_title.tr(),
          subtitle: AppLocalKay.helpCenter_subtitle.tr(),
          onTap: () => showHelpCenter(context),
        ),
        SettingItemWidget(
          icon: Icons.privacy_tip,
          title: AppLocalKay.privacyPolicy_title.tr(),
          subtitle: AppLocalKay.privacyPolicy_subtitle.tr(),
          onTap: () => showPrivacyPolicy(context),
        ),
        SettingItemWidget(
          icon: Icons.description,
          title: AppLocalKay.terms_title.tr(),
          subtitle: AppLocalKay.terms_subtitle.tr(),
          onTap: () => showTerms(context),
        ),
        SettingItemWidget(
          icon: Icons.info,
          title: AppLocalKay.about_title.tr(),
          subtitle: AppLocalKay.about_subtitle.tr(),
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
      applicationName: AppLocalKay.appName.tr(),
      applicationVersion: AppLocalKay.appVersion.tr(),
      applicationIcon: Icon(Icons.school, size: 50.w),
    );
  }
}
