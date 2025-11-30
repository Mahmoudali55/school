import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
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
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedTheme = 'فاتح';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: AppColor.hintColor(context),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCardWidget(),
            SizedBox(height: 24.h),
            SectionTitleWidget(title: 'إعدادات الحساب'),
            SizedBox(height: 16.h),
            AccountSettingsWidget(),
            SizedBox(height: 24.h),

            SectionTitleWidget(title: 'إعدادات المدرسة'),
            SizedBox(height: 16.h),
            SchoolSettingsWidget(),
            SizedBox(height: 24.h),

            SectionTitleWidget(title: 'إعدادات التطبيق'),
            SizedBox(height: 16.h),
            AppSettingsWidget(),
            SizedBox(height: 24.h),

            SectionTitleWidget(title: 'المعلومات'),
            SizedBox(height: 16.h),
            AppInfoWidget(),
            SizedBox(height: 32.h),

            ActionButtonsWidget(),
          ],
        ),
      ),
    );
  }
}
