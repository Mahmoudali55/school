import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showProfile = true;
  bool _showEmail = false;
  bool _showPhone = false;
  bool _allowSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.privacy.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.textColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                children: [
                  // Visual Header Card
                  _buildHeaderCard(context),
                  const Gap(24),

                  // Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      AppLocalKay.privacy_control.tr(),
                      style: AppTextStyle.titleSmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor(context).withOpacity(0.6),
                      ),
                    ),
                  ),
                  const Gap(10),

                  // Cohesive Grouped Settings Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.surfaceColor(context),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColor.borderColor(context), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowColor(context).withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildPrivacyOption(
                          icon: Icons.person_rounded,
                          iconBgColor: Colors.blue.withOpacity(0.1),
                          iconColor: Colors.blue,
                          title: AppLocalKay.show_profile.tr(),
                          subtitle: AppLocalKay.show_profile_hint.tr(),
                          value: _showProfile,
                          onChanged: (value) => setState(() => _showProfile = value),
                          showDivider: true,
                        ),
                        _buildPrivacyOption(
                          icon: Icons.email_rounded,
                          iconBgColor: Colors.amber.withOpacity(0.1),
                          iconColor: Colors.amber.shade700,
                          title: AppLocalKay.show_email.tr(),
                          subtitle: AppLocalKay.show_email_hint.tr(),
                          value: _showEmail,
                          onChanged: (value) => setState(() => _showEmail = value),
                          showDivider: true,
                        ),
                        _buildPrivacyOption(
                          icon: Icons.phone_rounded,
                          iconBgColor: Colors.green.withOpacity(0.1),
                          iconColor: Colors.green,
                          title: AppLocalKay.show_phone.tr(),
                          subtitle: "السماح للآخرين برؤية رقم الهاتف الخاص بك",
                          value: _showPhone,
                          onChanged: (value) => setState(() => _showPhone = value),
                          showDivider: true,
                        ),
                        _buildPrivacyOption(
                          icon: Icons.search_rounded,
                          iconBgColor: Colors.purple.withOpacity(0.1),
                          iconColor: Colors.purple,
                          title: "السماح بالبحث عنك",
                          subtitle: "السماح للآخرين بالعثور عليك من خلال محرك البحث",
                          value: _allowSearch,
                          onChanged: (value) => setState(() => _allowSearch = value),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const Gap(30),
                ],
              ),
            ),

            // Save Changes Button at the Bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                radius: 16.r,
                text: "حفظ التغييرات",
                gradient: LinearGradient(
                  colors: [
                    AppColor.secondAppColor(context),
                    AppColor.secondAppColor(context).withOpacity(0.85),
                  ],
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.secondAppColor(context),
            AppColor.secondAppColor(context).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondAppColor(context).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "أمانك وخصوصيتك أولاً",
                  style: AppTextStyle.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Gap(6),
                Text(
                  "تحكم بشكل كامل في مستوى خصوصية حسابك ومعلوماتك الشخصية وكيف تظهر للآخرين في المنصة.",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.r),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bodyLarge(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      subtitle,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.textColor(context).withOpacity(0.55),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: AppColor.primaryColor(context),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.8,
            color: AppColor.dividerColor(context).withOpacity(0.6),
            indent: 74.r,
            endIndent: 16.r,
          ),
      ],
    );
  }
}
