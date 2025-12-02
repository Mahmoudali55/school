import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.terms.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.terms_hint.tr(),
                  style: AppTextStyle.titleLarge(context, color: AppColor.blackColor(context)),
                ),
                const SizedBox(height: 20),
                _buildTermSection(
                  title: AppLocalKay.terms_title.tr(),
                  content: AppLocalKay.terms_content.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title2.tr(),
                  content: AppLocalKay.terms_content2.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title3.tr(),
                  content: AppLocalKay.terms_content3.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title4.tr(),
                  content: AppLocalKay.terms_content4.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title5.tr(),
                  content: AppLocalKay.terms_content5.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title6.tr(),
                  content: AppLocalKay.terms_content6.tr(),
                  context: context,
                ),
                _buildTermSection(
                  title: AppLocalKay.terms_title7.tr(),
                  content: AppLocalKay.terms_content7.tr(),
                  context: context,
                ),
                const SizedBox(height: 30),
                Card(
                  color: AppColor.primaryColor(context).withOpacity(0.11),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalKay.note.tr(),
                          style: AppTextStyle.titleSmall(
                            context,
                            color: AppColor.primaryColor(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(AppLocalKay.note_content.tr(), style: AppTextStyle.bodySmall(context)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  radius: 12.r,
                  text: AppLocalKay.terms_agree.tr(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermSection({
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.titleSmall(context, color: AppColor.blackColor(context))),
        const SizedBox(height: 8),
        Text(content, style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context))),
        const SizedBox(height: 20),
      ],
    );
  }
}
