import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/action_buttons_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/general_settings_section.dart';
import 'package:my_template/features/setting/presentation/screen/widget/support_section_widget.dart';

class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppLocalKay.settings.tr(),
                style: AppTextStyle.titleLarge(
                  context,
                  color: AppColor.blackColor(context),
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GeneralSettingsSection(),
                  const SizedBox(height: 20),
                  SupportSectionWidget(),
                  const SizedBox(height: 20),
                  ActionButtonsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
