import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
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
          children: [
            Center(
              child: Text(
                "الإعدادات",
                style: AppTextStyle.titleLarge(context, color: AppColor.blackColor(context)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GeneralSettingsSection(),
                  const SizedBox(height: 20),
                  SupportSectionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
