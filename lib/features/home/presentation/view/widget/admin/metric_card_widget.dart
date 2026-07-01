import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/glass_container.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/metric_card_model.dart';

class MetricCardWidget extends StatelessWidget {
  final MetricCard metric;
  const MetricCardWidget({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: MediaQuery.sizeOf(context).width * 0.3,
      borderRadius: 24.r,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      opacity: 0.05,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                color: metric.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(metric.icon, color: metric.color, size: 18.w),
            ),
            Gap(8.h),
            Text(
              metric.value,
              maxLines: 1,
              style: AppTextStyle.titleLarge(context).copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Gap(2.h),
            Text(
              metric.title,
              maxLines: 1,
              style: AppTextStyle.bodySmall(context, color: AppColor.grey600Color(context)).copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}