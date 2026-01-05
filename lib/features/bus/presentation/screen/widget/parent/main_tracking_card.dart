import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';

class MainTrackingCard extends StatelessWidget {
  final BusClass selectedBusData;
  final Animation<double> busAnimation;
  final VoidCallback onCallDriver;
  final VoidCallback onShareLocation;
  final VoidCallback onSetArrivalAlert;

  const MainTrackingCard({
    super.key,
    required this.selectedBusData,
    required this.busAnimation,
    required this.onCallDriver,
    required this.onShareLocation,
    required this.onSetArrivalAlert,
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
          _buildChildHeader(context),
          SizedBox(height: 20.h),
          _buildMapSection(context),
          SizedBox(height: 20.h),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildChildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: selectedBusData.busColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_rounded, color: selectedBusData.busColor, size: 24.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedBusData.childName ?? "",
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Text(
                "${selectedBusData.subject} - ${selectedBusData.className}",
                style: AppTextStyle.bodyMedium(context).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: selectedBusData.status == 'في الطريق'
                ? AppColor.secondAppColor(context).withOpacity(0.1)
                : AppColor.accentColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            selectedBusData.status == 'في الطريق'
                ? AppLocalKay.in_bus.tr()
                : AppLocalKay.waiting.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(
              color: selectedBusData.status == 'في الطريق'
                  ? AppColor.secondAppColor(context)
                  : AppColor.accentColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selectedBusData.busColor.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
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
          Positioned(
            left: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.home_rounded, color: AppColor.secondAppColor(context), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  AppLocalKay.home_address.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: AppColor.primaryColor(context), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  AppLocalKay.school.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _buildAnimatedBus(context),
        ],
      ),
    );
  }

  Widget _buildAnimatedBus(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.3,
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
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            context,
            AppLocalKay.share_location.tr(),
            Icons.share_rounded,
            AppColor.primaryColor(context),
            onShareLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            context,
            AppLocalKay.arrival_alert.tr(),
            Icons.notifications_rounded,
            AppColor.accentColor(context),
            onSetArrivalAlert,
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
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.w),
            SizedBox(height: 10.w),
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
