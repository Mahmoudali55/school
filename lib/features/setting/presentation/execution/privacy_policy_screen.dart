// lib/features/settings/presentation/screens/privacy_policy_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.privacy_policy.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalKay.last_update.tr(), style: AppTextStyle.bodyMedium(context)),
                    SizedBox(height: 8.h),
                    Text(AppLocalKay.intro.tr(), style: AppTextStyle.bodyMedium(context)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section1_title.tr(),
              AppLocalKay.section1_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section2_title.tr(),
              AppLocalKay.section2_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section3_title.tr(),
              AppLocalKay.section3_content.tr(),

              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section4_title.tr(),
              AppLocalKay.section4_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section5_title.tr(),
              AppLocalKay.section5_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section6_title.tr(),
              AppLocalKay.section6_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section7_title.tr(),
              AppLocalKay.section7_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              AppLocalKay.section8_title.tr(),
              AppLocalKay.section8_content.tr(),
              context,
            ),
            SizedBox(height: 32.h),

            // موافقة
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalKay.consent_title.tr(),
                      style: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.green[800]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalKay.consent_text.tr(),
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(height: 1.6, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Text(
          content,
          style: AppTextStyle.bodyMedium(context).copyWith(height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
