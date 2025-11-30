import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: () => logout(context),
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
                  style: TextStyle(fontSize: 16.sp, color: AppColor.errorColor(context)),
                ),
              ],
            ),
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
