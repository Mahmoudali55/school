import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
      appBar: CustomAppBar(
        context,
        title: Text(
          'إعدادات الخصوصية',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التحكم في إعدادات الخصوصية',
              style: AppTextStyle.bodyLarge(context, color: AppColor.greyColor(context)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPrivacyOption(
                    icon: Icons.person,
                    title: 'إظهار الملف الشخصي',
                    subtitle: 'السماح للآخرين برؤية ملفك الشخصي',
                    value: _showProfile,
                    onChanged: (value) => setState(() => _showProfile = value),
                  ),
                  _buildPrivacyOption(
                    icon: Icons.email,
                    title: 'إظهار البريد الإلكتروني',
                    subtitle: 'إظهار بريدك الإلكتروني للآخرين',
                    value: _showEmail,
                    onChanged: (value) => setState(() => _showEmail = value),
                  ),
                  _buildPrivacyOption(
                    icon: Icons.phone,
                    title: 'إظهار رقم الهاتف',
                    subtitle: 'إظهار رقم هاتفك للآخرين',
                    value: _showPhone,
                    onChanged: (value) => setState(() => _showPhone = value),
                  ),
                  _buildPrivacyOption(
                    icon: Icons.search,
                    title: 'السماح بالبحث عنك',
                    subtitle: 'السماح للآخرين بالعثور عليك من خلال البحث',
                    value: _allowSearch,
                    onChanged: (value) => setState(() => _allowSearch = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'حفظ التغييرات',
              radius: 12.r,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primaryColor(context)),
        title: Text(title, style: AppTextStyle.bodyMedium(context)),
        subtitle: Text(
          subtitle,
          style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context)),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColor.primaryColor(context),
        ),
      ),
    );
  }
}
