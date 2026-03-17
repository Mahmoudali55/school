import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';

class AdminBusRouteBottomSheet extends StatelessWidget {
  final BusDataModel busData;

  const AdminBusRouteBottomSheet({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Gap(20.h),
          Text(
            "تفاصيل خط السير",
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          Gap(20.h),
          _buildRouteTimeline(context),
          Gap(20.h),
        ],
      ),
    );
  }

  Widget _buildRouteTimeline(BuildContext context) {
    return Column(
      children: [
        _buildTimelineItem(context, 'نقطة الانطلاق', busData.lineNameAr ?? "غير محدد", true),
        _buildTimelineItem(context, 'المنطقة', busData.addressAr ?? "غير محدد", false),
        _buildTimelineItem(
          context,
          'الوجهة',
          busData.sectionNameAr ?? "المدرسة",
          true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String subtitle,
    bool isMain, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: isMain ? AppColor.primaryColor(context) : Colors.grey[400],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            if (!isLast) Container(width: 2.w, height: 40.h, color: Colors.grey[300]),
          ],
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600])),
              Gap(4.h),
              Text(
                subtitle,
                style: AppTextStyle.bodyMedium(context).copyWith(
                  fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                  color: const Color(0xFF1F2937),
                ),
              ),
              if (!isLast) Gap(20.h),
            ],
          ),
        ),
      ],
    );
  }
}
