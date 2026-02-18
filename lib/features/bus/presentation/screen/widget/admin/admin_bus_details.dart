import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';

class AdminBusDetails extends StatelessWidget {
  final BusDataModel selectedBusData;

  const AdminBusDetails({super.key, required this.selectedBusData});

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
          Text(
            AppLocalKay.route_details.tr(),
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          Gap(16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1,
            children: [
              /// Bus Number (using Plate No)
              _buildDetailItem(
                context,
                AppLocalKay.bus_number.tr(),
                selectedBusData.plateNo ?? selectedBusData.busCode.toString(),
                Icons.directions_bus_rounded,
              ),

              /// Driver Name
              _buildDetailItem(
                context,
                AppLocalKay.driver.tr(),
                selectedBusData.driverNameAr ?? "-",
                Icons.person_rounded,
              ),

              /// Supervisor
              _buildDetailItem(
                context,
                "المشرف",
                selectedBusData.supervisorNameAr1 ?? "-",
                Icons.supervisor_account_rounded,
              ),

              /// Line Name
              _buildDetailItem(
                context,
                "خط السير",
                selectedBusData.lineNameAr ?? "-",
                Icons.route_rounded,
              ),

              /// Section
              _buildDetailItem(
                context,
                "القسم",
                selectedBusData.sectionNameAr ?? "-",
                Icons.school_rounded,
              ),

              /// Company
              _buildDetailItem(
                context,
                "الشركة",
                selectedBusData.companyName ?? "-",
                Icons.business_rounded,
              ),

              /// Seats
              _buildDetailItem(
                context,
                AppLocalKay.capacity.tr(),
                selectedBusData.busSets.toString(),
                Icons.event_seat_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColor.primaryColor(context).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: AppColor.blackColor(context)),
          ),
          Gap(10.h),
          Text(
            title,
            style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
          ),
          Text(
            value,
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
