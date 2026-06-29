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
