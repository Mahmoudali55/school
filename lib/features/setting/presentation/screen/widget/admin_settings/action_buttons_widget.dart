import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          radius: 12.r,
          width: double.infinity,
          color: AppColor.errorColor(context),
          onPressed: () => logout(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppColor.whiteColor(context)),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.logout.tr(),
                style: AppTextStyle.bodyLarge(context, color: AppColor.whiteColor(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: تنفيذ تسجيل الخروج
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تسجيل الخروج بنجاح'),
                  backgroundColor: AppColor.secondAppColor(context),
                ),
              );
            },
            child: Text('تسجيل الخروج', style: TextStyle(color: AppColor.errorColor(context))),
          ),
        ],
      );
    },
  );
}
