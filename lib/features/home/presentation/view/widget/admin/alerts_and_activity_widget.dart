import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/activity_Item_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/alert_Item_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/widgets/dashboard_section_header.dart';

class AlertsAndActivity extends StatelessWidget {
  const AlertsAndActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(
          title: AppLocalKay.notificationsAndActivities.tr(),
          actionText: AppLocalKay.show_all.tr(),
          onActionPressed: () {
            Navigator.pushNamed(context, RoutesName.notificationsScreen);
          },
        ),
        Gap(16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
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
              Divider(height: 24.h, color: AppColor.greyColor(context).withValues(alpha: 0.1)),
              ActivityItem(
                activity: Activity(user: "أ. محمد أحمد", action: "تعديل جدول", time: "منذ 10 دقائق"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
