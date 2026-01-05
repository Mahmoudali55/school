import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class AdminAllBusesStatus extends StatelessWidget {
  final List<BusModel> allBusesData;

  const AdminAllBusesStatus({super.key, required this.allBusesData});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalKay.all_buses.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${allBusesData.length} حافلات",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: const Color(0xFF9C27B0), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: allBusesData.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) => _buildBusStatusItem(context, allBusesData[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusStatusItem(BuildContext context, BusModel busData) {
    Color statusColor;
    switch (busData.status) {
      case 'في الطريق':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'في المحطة':
        statusColor = const Color(0xFF2196F3);
        break;
      case 'متأخرة':
        statusColor = const Color(0xFFFF9800);
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Bus Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: busData.busColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_bus_rounded, color: busData.busColor, size: 18.w),
          ),
          SizedBox(width: 8.w),
          // Bus Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${busData.busName} - ${busData.busNumber}",
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${busData.driverName} • ${busData.currentLocation}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  busData.status,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 9.sp, color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                busData.estimatedTime,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontSize: 10.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
