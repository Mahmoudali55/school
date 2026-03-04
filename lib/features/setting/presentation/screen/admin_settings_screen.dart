import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/account_settings.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/action_buttons_widget.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/app_info_widget.dart';
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

              Gap(24.h),
              SectionTitleWidget(title: AppLocalKay.setting_account.tr()),
              Gap(16.h),
              AccountSettingsWidget(),
              Gap(24.h),
              SectionTitleWidget(title: AppLocalKay.setting_school.tr()),
              Gap(16.h),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  final String currentLangCode = state is SettingsLoaded
                      ? state.settings.languageCode
                      : context.locale.languageCode;
                  final String _selectedLanguage = currentLangCode == 'ar'
                      ? AppLocalKay.arabic.tr()
                      : AppLocalKay.english.tr();

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.language, color: AppColor.primaryColor(context)),
                      title: Text(
                        AppLocalKay.language.tr(),
                        style: AppTextStyle.bodyLarge(context),
                      ),
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
                          final String newLangCode = newValue == AppLocalKay.arabic.tr()
                              ? 'ar'
                              : 'en';
                          context.setLocale(Locale(newLangCode));
                          context.read<SettingsCubit>().updateLanguage(newLangCode);
                        },
                        underline: SizedBox(),
                      ),
                    ),
                  );
                },
              ),
              SchoolSettingsWidget(),
              //Gap(24.h),
              // SectionTitleWidget(title: AppLocalKay.setting_app.tr()),
              // Gap(16.h),
              // AppSettingsWidget(),
              Gap(24.h),
              SectionTitleWidget(title: AppLocalKay.setting_info.tr()),
              Gap(16.h),
              AppInfoWidget(),
              Gap(32.h),
              ActionButtonsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
