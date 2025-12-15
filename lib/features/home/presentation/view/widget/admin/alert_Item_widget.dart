import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';

class AlertItem extends StatelessWidget {
  final Alert alert;
  const AlertItem({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    Color alertColor = alert.type == AlertType.security
        ? AppColor.warningColor(context)
        : AppColor.accentColor(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: alertColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                ),
                Text(
                  alert.description,
                  style: AppTextStyle.bodySmall(
                    context,
                    color: Colors.grey[700],
                  ).copyWith(fontSize: 10.sp),
                ),
                Text(
                  alert.time,
                  style: AppTextStyle.bodySmall(
                    context,
                    color: Colors.grey[400],
                  ).copyWith(fontSize: 8.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
