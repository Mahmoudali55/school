import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
                SnackBar(content: Text('تم تسجيل الخروج بنجاح'), backgroundColor: Colors.green),
              );
            },
            child: Text('تسجيل الخروج', style: TextStyle(color: AppColor.errorColor(context))),
          ),
        ],
      );
    },
  );
}
