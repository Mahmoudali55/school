import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class FleetManagement extends StatelessWidget {
  final BusModel selectedBusData;

  const FleetManagement({super.key, required this.selectedBusData});

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
              Icon(Icons.manage_accounts_rounded, color: const Color(0xFF9C27B0), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.buses_section.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1,
            children: [
              _buildManagementItem(
                context,
                AppLocalKay.performance_report.tr(),
                "${selectedBusData.attendanceRate} حضور",
                Icons.assessment_rounded,
                AppColor.secondAppColor(context),
              ),
              _buildManagementItem(
                context,
                AppLocalKay.status.tr(),
                selectedBusData.maintenanceStatus,
                Icons.build_rounded,
                AppColor.accentColor(context),
              ),
              _buildManagementItem(
                context,
                AppLocalKay.fuel_level.tr(),
                selectedBusData.fuelLevel,
                Icons.local_gas_station_rounded,
                AppColor.primaryColor(context),
              ),
              _buildManagementItem(
                context,
                AppLocalKay.passengers_on_board.tr(),
                selectedBusData.studentsOnBoard,
                Icons.people_alt_rounded,
                const Color(0xFF9C27B0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(icon, size: 16.w, color: color),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: const Color(0xFF6B7280), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
