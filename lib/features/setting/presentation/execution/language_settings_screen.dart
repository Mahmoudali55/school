import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String? _selectedLanguage = AppLocalKay.arabic.tr();

  final List<Map<String, dynamic>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'nativeName': 'العربية'},
    {'code': 'en', 'name': 'الإنجليزية', 'nativeName': 'English'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.language_settings.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.favorite_language.tr(),
                style: AppTextStyle.bodyLarge(context, color: AppColor.greyColor(context)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: RadioListTile<String>(
                        title: Text(language['name'], style: AppTextStyle.bodyMedium(context)),
                        subtitle: Text(
                          language['nativeName'],
                          style: AppTextStyle.bodySmall(
                            context,
                            color: AppColor.greyColor(context),
                          ),
                        ),
                        value: language['code'],
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                          // هنا يمكن إضافة منطق تغيير اللغة
                        },
                        activeColor: AppColor.primaryColor(context),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(radius: 12, text: AppLocalKay.save_changes.tr(), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
