import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/execution/contact_us_screen.dart';
import 'package:my_template/features/setting/presentation/execution/terms_conditions_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/settings_tile_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SettingsTileWidget(
            icon: Icons.help_outline,
            title: AppLocalKay.help.tr(),
            onTap: () {
              _navigateTohelpSupport(context);
            },
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.support_agent,
            title: AppLocalKay.contact_us.tr(),
            onTap: () {
              _navigateToContactUs(context);
            },
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.description,
            title: AppLocalKay.terms.tr(),
            onTap: () {
              _navigateTermsConditionsScreen(context);
            },
          ),
          divider(),
          SettingsTileWidget(
            icon: Icons.info,
            title: AppLocalKay.about.tr(),
            onTap: () {
              _navigateToAboutApp(context);
            },
          ),
        ],
      ),
    );
  }

  Widget divider() => const Divider(height: 1, color: Colors.grey, indent: 16, endIndent: 16);
  void _navigateTohelpSupport(BuildContext context) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen()));
  }

  void _navigateToContactUs(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
  }

  void _navigateToAboutApp(BuildContext context) {
    //  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutAppScreen()));
  }

  void _navigateTermsConditionsScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionsScreen()));
  }
}
