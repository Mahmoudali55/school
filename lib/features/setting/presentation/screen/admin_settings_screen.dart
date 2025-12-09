import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/account_settings.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/action_buttons_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/app_info_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/app_settings_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/profile_card_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/school_settings_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/section_title_widget.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    String _selectedLanguage = context.locale.languageCode == 'ar'
        ? AppLocalKay.arabic.tr()
        : AppLocalKay.english.tr();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: SafeArea(
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
              ProfileCardWidget(),
              SizedBox(height: 24.h),
              SectionTitleWidget(title: AppLocalKay.setting_account.tr()),
              SizedBox(height: 16.h),
              AccountSettingsWidget(),
              SizedBox(height: 24.h),

              SectionTitleWidget(title: AppLocalKay.setting_school.tr()),
              SizedBox(height: 16.h),
              Card(
                child: ListTile(
                  leading: Icon(Icons.language, color: AppColor.primaryColor(context)),
                  title: Text(AppLocalKay.language.tr(), style: AppTextStyle.bodyLarge(context)),
                  subtitle: Text(_selectedLanguage),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: [AppLocalKay.arabic.tr(), AppLocalKay.english.tr()]
                        .map(
                          (String value) =>
                              DropdownMenuItem<String>(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue == AppLocalKay.arabic.tr()) {
                        context.setLocale(Locale('ar'));
                      } else {
                        context.setLocale(Locale('en'));
                      }
                    },
                    underline: SizedBox(),
                  ),
                ),
              ),
              SchoolSettingsWidget(),
              SizedBox(height: 24.h),

              SectionTitleWidget(title: AppLocalKay.setting_app.tr()),
              SizedBox(height: 16.h),
              AppSettingsWidget(),
              SizedBox(height: 24.h),

              SectionTitleWidget(title: AppLocalKay.setting_info.tr()),
              SizedBox(height: 16.h),
              AppInfoWidget(),
              SizedBox(height: 32.h),

              ActionButtonsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
