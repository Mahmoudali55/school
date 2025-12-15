import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class UpcomingTasksSection extends StatelessWidget {
  const UpcomingTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ("حل تمارين الرياضيات", "الرياضيات", "غداً", AppColor.warningColor(context)),
      ("بحث عن النظام الشمسي", "العلوم", "بعد ٣ أيام", AppColor.accentColor(context)),
      ("اختبار الوحدة الثانية", "العربية", "الأسبوع القادم", AppColor.secondAppColor(context)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.no_notifications.tr(),
          style: AppTextStyle.headlineMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Column(
          children: tasks.map((task) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: task.$4.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.assignment, color: task.$4, size: 20.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.$1,
                          style: AppTextStyle.titleSmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              task.$2,
                              style: AppTextStyle.bodySmall(
                                context,
                                color: AppColor.primaryColor(context),
                              ).copyWith(fontSize: 11.sp),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.calendar_today,
                              size: 12.w,
                              color: AppColor.greyColor(context),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              task.$3,
                              style: AppTextStyle.bodySmall(
                                context,
                                color: AppColor.greyColor(context),
                              ).copyWith(fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
