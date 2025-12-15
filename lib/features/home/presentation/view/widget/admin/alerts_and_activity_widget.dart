import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/activity_Item_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/alert_Item_widget.dart';

class AlertsAndActivity extends StatelessWidget {
  const AlertsAndActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalKay.notificationsAndActivities.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.notificationsScreen);
              },
              child: Text(
                AppLocalKay.show_all.tr(),
                style: AppTextStyle.bodySmall(context).copyWith(fontSize: 12.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          children: [
            AlertItem(
              alert: Alert(
                title: "انتهاء الترخيص",
                description: "ينتهي خلال 15 يوم",
                type: AlertType.technical,
                time: "منذ ساعتين",
                isUrgent: true,
              ),
            ),
            ActivityItem(
              activity: Activity(user: "أ. محمد أحمد", action: "تعديل جدول", time: "منذ 10 دقائق"),
            ),
          ],
        ),
      ],
    );
  }
}
