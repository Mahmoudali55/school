import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late String _selectedLanguage;

  final List<Map<String, dynamic>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'nativeName': 'Arabic', 'flag': '🇸🇦'},
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = context.locale.languageCode;
  }

  Future<void> _updateLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode) return;

    setState(() {
      _selectedLanguage = languageCode;
    });

    await context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.language_settings.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        centerTitle: true,
        appBarColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColor.primaryColor(context),
          size: 24.sp,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalKay.favorite_language.tr(),
              style: AppTextStyle.bodyLarge(
                context,
              ).copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                itemCount: _languages.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  final isSelected = _selectedLanguage == language['code'];

                  return GestureDetector(
                    onTap: () => _updateLanguage(language['code']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.primaryColor(context).withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.primaryColor(context)
                              : Colors.grey.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: Offset(0, 4.h),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.primaryColor(context).withOpacity(0.1)
                                  : Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(language['flag'], style: TextStyle(fontSize: 24.sp)),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language['name'],
                                  style: AppTextStyle.bodyLarge(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColor.primaryColor(context)
                                        : Colors.black87,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  language['nativeName'],
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(color: Colors.grey[500], fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor(context),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: Colors.white, size: 16.sp),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
