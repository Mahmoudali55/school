import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';

showLanguageSheet(BuildContext parentContext) {
  showModalBottomSheet(
    context: parentContext,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalKay.language.tr(),
                style: AppTextStyle.headlineMedium(
                  bottomSheetContext,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Image.asset('assets/global_icon/eng_flag.png', width: 30, height: 30),
                title: Text(
                  AppLocalKay.english.tr(),
                  style: AppTextStyle.text16MSecond(
                    bottomSheetContext,
                    color: AppColor.secondAppColor(bottomSheetContext),
                  ),
                ),
                onTap: () {
                  parentContext.setLocale(const Locale('en'));
                  parentContext.read<SettingsCubit>().updateLanguage('en');
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                leading: Image.asset('assets/global_icon/saudi_flag.png', width: 30, height: 30),
                title: Text(
                  AppLocalKay.arabic.tr(),
                  style: AppTextStyle.text16MSecond(
                    bottomSheetContext,
                    color: AppColor.blackColor(bottomSheetContext),
                  ),
                ),
                onTap: () {
                  parentContext.setLocale(const Locale('ar'));
                  parentContext.read<SettingsCubit>().updateLanguage('ar');
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
