import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class QuickOverview extends StatelessWidget {
  final int childrenCount;
  final int inBusCount;
  final String nearestArrival;
  final String safetyStatus;

  const QuickOverview({
    super.key,
    required this.childrenCount,
    required this.inBusCount,
    required this.nearestArrival,
    required this.safetyStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem(
            context,
            childrenCount.toString(),
            AppLocalKay.children.tr(),
            Icons.family_restroom_rounded,
            AppColor.secondAppColor(context),
          ),
          _buildOverviewItem(
            context,
            inBusCount.toString(),
            AppLocalKay.in_bus.tr(),
            Icons.directions_bus_rounded,
            AppColor.primaryColor(context),
          ),
          _buildOverviewItem(
            context,
            nearestArrival,
            AppLocalKay.nearest_arrival.tr(),
            Icons.schedule_rounded,
            AppColor.accentColor(context),
          ),
          _buildOverviewItem(
            context,
            safetyStatus,
            AppLocalKay.safe.tr(),
            Icons.verified_rounded,
            const Color(0xFFEC4899),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyle.bodyLarge(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor(context),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
