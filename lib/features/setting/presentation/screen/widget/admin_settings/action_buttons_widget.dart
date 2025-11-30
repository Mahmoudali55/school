import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/logout_widget.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: logout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.errorColor(context),
              side: BorderSide(color: AppColor.errorColor(context)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppColor.errorColor(context)),
                SizedBox(width: 8.w),
                Text(
                  'تسجيل الخروج',
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.errorColor(context)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
