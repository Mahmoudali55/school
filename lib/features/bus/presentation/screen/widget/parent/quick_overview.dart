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
  final String? nextStop;
  final String? lastUpdate;
  final String? driverName;
  final String? busNumber;
  final String? attendanceRate;
  final Function(String)? onItemTapped;

  const QuickOverview({
    super.key,
    required this.childrenCount,
    required this.inBusCount,
    required this.nearestArrival,
    required this.safetyStatus,
    this.nextStop,
    this.lastUpdate,
    this.driverName,
    this.busNumber,
    this.attendanceRate,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem(
                context,
                childrenCount.toString(),
                AppLocalKay.children.tr(),
                Icons.family_restroom_rounded,
                AppColor.secondAppColor(context),
                'children',
              ),
              _buildOverviewItem(
                context,
                inBusCount.toString(),
                AppLocalKay.in_bus.tr(),
                Icons.directions_bus_rounded,
                AppColor.primaryColor(context),
                'in_bus',
              ),
              _buildOverviewItem(
                context,
                nearestArrival,
                AppLocalKay.nearest_arrival.tr(),
                Icons.schedule_rounded,
                AppColor.accentColor(context),
                'arrival',
              ),
              _buildOverviewItem(
                context,
                attendanceRate ?? safetyStatus,
                attendanceRate != null ? "نسبة الحضور" : AppLocalKay.safe.tr(),
                attendanceRate != null ? Icons.analytics_rounded : Icons.verified_rounded,
                const Color(0xFF10B981),
                'attendance',
              ),
            ],
          ),
          if (driverName != null || busNumber != null || nextStop != null) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.white.withOpacity(0.1), height: 1),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (driverName != null)
                  _buildSecondaryItem(
                    context,
                    driverName!,
                    AppLocalKay.driver.tr(),
                    Icons.person_pin_rounded,
                    'driver',
                  ),
                if (busNumber != null)
                  _buildSecondaryItem(
                    context,
                    busNumber!,
                    AppLocalKay.bus_number.tr(),
                    Icons.confirmation_number_rounded,
                    'bus',
                  ),
                if (nextStop != null)
                  _buildSecondaryItem(
                    context,
                    nextStop!,
                    "المحطة القادمة",
                    Icons.near_me_rounded,
                    'stop',
                  ),
              ],
            ),
          ],
          if (lastUpdate != null) ...[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off_rounded, size: 12.w, color: const Color(0xFF94A3B8)),
                SizedBox(width: 4.w),
                Text(
                  "${"آخر تحديث"}: $lastUpdate",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: const Color(0xFF94A3B8), fontSize: 10.sp),
                ),
              ],
            ),
          ],
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
    String type,
  ) {
    return GestureDetector(
      onTap: () => onItemTapped?.call(type),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: AppTextStyle.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor(context),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyle.bodySmall(context).copyWith(
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    String type,
  ) {
    return GestureDetector(
      onTap: () => onItemTapped?.call(type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.w, color: AppColor.primaryColor(context)),
                SizedBox(width: 6.w),
                Text(
                  value,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: const Color(0xFF94A3B8), fontSize: 9.sp),
            ),
          ],
        ),
      ),
    );
  }
}
