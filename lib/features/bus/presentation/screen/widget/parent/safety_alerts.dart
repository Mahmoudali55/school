import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SafetyAlerts extends StatelessWidget {
  final ValueChanged<String> onFeatureTap;

  const SafetyAlerts({super.key, required this.onFeatureTap});

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
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: AppColor.primaryColor(context),
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.features.tr(),
                style: AppTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildSafetyFeature(
                  context,
                  AppLocalKay.arrival_alert.tr(),
                  Icons.notifications_active_rounded,
                  const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  context,
                  AppLocalKay.follow_route.tr(),
                  Icons.travel_explore_rounded,
                  AppColor.primaryColor(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  context,
                  AppLocalKay.report_incident.tr(),
                  Icons.report_problem_rounded,
                  AppColor.accentColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyFeature(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => onFeatureTap(title),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.w, color: color),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
