import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class BusDetails extends StatelessWidget {
  final Map<String, dynamic> selectedBusData;

  const BusDetails({super.key, required this.selectedBusData});

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
            style: AppTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1,
            children: [
              _buildDetailItem(
                context,
                AppLocalKay.bus_number.tr(),
                selectedBusData['busNumber'],
                Icons.directions_bus_rounded,
              ),
              _buildDetailItem(
                context,
                AppLocalKay.driver.tr(),
                selectedBusData['driverName'],
                Icons.person_rounded,
              ),
              _buildDetailItem(
                context,
                AppLocalKay.phone.tr(),
                selectedBusData['driverPhone'],
                Icons.phone_rounded,
              ),
              _buildDetailItem(
                context,
                AppLocalKay.current_location.tr(),
                selectedBusData['currentLocation'],
                Icons.location_on_rounded,
              ),
              _buildDetailItem(
                context,
                AppLocalKay.next_stop.tr(),
                selectedBusData['nextStop'],
                Icons.flag_rounded,
              ),
              _buildDetailItem(
                context,
                AppLocalKay.capacity.tr(),
                "${selectedBusData['occupiedSeats']}/${selectedBusData['capacity']}",
                Icons.people_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: selectedBusData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: selectedBusData['busColor']),
          ),
          SizedBox(height: 8.w),
          Text(
            title,
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(color: const Color(0xFF6B7280)),
          ),
          SizedBox(height: 8.w),
          Text(
            value,
            style: AppTextStyle.titleSmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
