import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class BusStatusHeader extends StatelessWidget {
  final BusModel busData;
  const BusStatusHeader({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.secondAppColor(context).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: AppColor.secondAppColor(context),
            size: 24.w,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الحافلة ${busData.busNumber}",
                style: AppTextStyle.bodyMedium(context, color: const Color(0xFF1F2937)),
              ),
              Text(
                busData.status,
                style: AppTextStyle.bodyMedium(context, color: AppColor.secondAppColor(context)),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColor.primaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            busData.estimatedTime,
            style: AppTextStyle.bodyMedium(context, color: AppColor.primaryColor(context)),
          ),
        ),
      ],
    );
  }
}
