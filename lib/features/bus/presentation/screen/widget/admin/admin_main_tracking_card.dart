import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class AdminMainTrackingCard extends StatelessWidget {
  final BusModel selectedBusData;
  final Animation<double> busAnimation;
  final VoidCallback onCallDriver;
  final VoidCallback onRefreshLocation;
  final VoidCallback onSendAlert;

  const AdminMainTrackingCard({
    super.key,
    required this.selectedBusData,
    required this.busAnimation,
    required this.onCallDriver,
    required this.onRefreshLocation,
    required this.onSendAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bus & Driver Header
          _buildBusHeader(context),
          SizedBox(height: 20.h),
          // Map Section
          _buildMapSection(context),
          SizedBox(height: 20.h),
          // Quick Actions
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildBusHeader(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (selectedBusData.status) {
      case 'في الطريق':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.directions_bus_rounded;
        break;
      case 'في المحطة':
        statusColor = const Color(0xFF2196F3);
        statusIcon = Icons.location_on_rounded;
        break;
      case 'متأخرة':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.schedule_rounded;
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
        statusIcon = Icons.directions_bus_rounded;
    }

    return Row(
      children: [
        // Bus Avatar
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: selectedBusData.busColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_bus_rounded, color: selectedBusData.busColor, size: 24.w),
        ),
        SizedBox(width: 12.w),
        // Bus Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${selectedBusData.busName} - ${selectedBusData.busNumber}",
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Text(
                "السائق: ${selectedBusData.driverName} • ${selectedBusData.route}",
                style: AppTextStyle.bodyMedium(context).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 14.w, color: statusColor),
              SizedBox(width: 4.w),
              Text(
                selectedBusData.status,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selectedBusData.busColor.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          // Route Line
          Positioned(
            top: 90.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: selectedBusData.busColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // School Icon
          Positioned(
            left: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: const Color(0xFF2196F3), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  "المدرسة",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Multiple Stops
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.location_on_rounded, color: const Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "المحطة 1",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 8.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.location_on_rounded, color: const Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "المحطة 2",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 8.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Animated Bus
          _buildAnimatedBus(context),
        ],
      ),
    );
  }

  Widget _buildAnimatedBus(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.45,
      top: 70.h,
      child: AnimatedBuilder(
        animation: busAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, busAnimation.value),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_bus_rounded,
                color: selectedBusData.busColor,
                size: 32.w,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      spacing: 5.w,
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            AppLocalKay.call_driver.tr(),
            Icons.phone_rounded,
            AppColor.secondAppColor(context),
            onCallDriver,
          ),
        ),
        Expanded(
          child: _buildActionButton(
            context,
            AppLocalKay.update_location.tr(),
            Icons.refresh_rounded,
            AppColor.primaryColor(context),
            onRefreshLocation,
          ),
        ),
        Expanded(
          child: _buildActionButton(
            context,
            AppLocalKay.send_alert.tr(),
            Icons.notifications_rounded,
            AppColor.accentColor(context),
            onSendAlert,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.w),
            SizedBox(width: 8.w),
            Text(
              text,
              style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
