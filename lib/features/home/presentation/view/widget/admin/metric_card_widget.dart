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
      width: 150.w,
      borderRadius: 24.r,
      padding: EdgeInsets.all(16.w),
      opacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(metric.icon, color: metric.color, size: 20.w),
              ),
              if (metric.change.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (metric.isPositive ? AppColor.successColor(context) : AppColor.errorColor(context)).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        metric.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 10.sp,
                        color: metric.isPositive ? AppColor.successColor(context) : AppColor.errorColor(context),
                      ),
                      Gap(2.w),
                      Text(
                        metric.change,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 10.sp,
                          color: metric.isPositive ? AppColor.successColor(context) : AppColor.errorColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.value,
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
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bodySmall(context, color: AppColor.grey600Color(context)).copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
