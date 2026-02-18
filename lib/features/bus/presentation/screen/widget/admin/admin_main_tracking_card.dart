import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';

class AdminMainTrackingCard extends StatelessWidget {
  final BusDataModel selectedBusData;
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
          Gap(20.h),

          // Map Section
          Gap(20.h),
          // Quick Actions
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildBusHeader(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    return Row(
      children: [
        // Bus Avatar
        Gap(12.w),
        // Bus Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${selectedBusData.busType} - ${selectedBusData.plateNo ?? selectedBusData.busCode}",
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Text(
                "${AppLocalKay.driver.tr()}: ${selectedBusData.driverNameAr} • ${selectedBusData.lineNameAr}",
                style: AppTextStyle.bodyMedium(context).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
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
            Gap(8.w),
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
