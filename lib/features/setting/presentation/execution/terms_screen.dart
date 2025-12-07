// lib/features/settings/presentation/screens/terms_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.terms_title.tr(),
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
                    Text(
                      'آخر تحديث: 20 مارس 2024',
                      style: AppTextStyle.titleSmall(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: AppColor.greyColor(context)),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام تطبيق إدارة المدرسة.',
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.greyColor(context)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_1_title.tr(),
              AppLocalKay.terms_section_1_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_2_title.tr(),
              AppLocalKay.terms_section_2_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_3_title.tr(),
              AppLocalKay.terms_section_3_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_4_title.tr(),
              AppLocalKay.terms_section_4_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_5_title.tr(),
              AppLocalKay.terms_section_5_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_6_title.tr(),
              AppLocalKay.terms_section_6_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_7_title.tr(),
              AppLocalKay.terms_section_7_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_8_title.tr(),
              AppLocalKay.terms_section_8_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_9_title.tr(),
              AppLocalKay.terms_section_9_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_10_title.tr(),
              AppLocalKay.terms_section_10_content.tr(),
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              AppLocalKay.terms_section_11_title.tr(),
              AppLocalKay.terms_section_11_content.tr(),
              context,
            ),
            SizedBox(height: 32.h),

            // تنويه
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalKay.terms_important_note_title.tr(),
                      style: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.orange[700]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalKay.terms_important_note_content.tr(),
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(height: 1.6, color: Colors.orange[700]),
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

  Widget _buildTermSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: AppTextStyle.bodyMedium(
            context,
          ).copyWith(height: 1.6, color: AppColor.greyColor(context)),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
