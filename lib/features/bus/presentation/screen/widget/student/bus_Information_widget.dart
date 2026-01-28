import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/Info_row_widget.dart';

class BusInformation extends StatelessWidget {
  final BusModel busData;
  const BusInformation({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            AppLocalKay.route_info.tr(),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          InfoRow(label: AppLocalKay.driver.tr(), value: busData.driverName),
          InfoRow(label: AppLocalKay.phone.tr(), value: busData.driverPhone),
          if (busData.supervisorName != null)
            InfoRow(label: "المشرف", value: busData.supervisorName!),
          if (busData.supervisorPhone != null)
            InfoRow(label: "جوال المشرف", value: busData.supervisorPhone!),
          if (busData.busType != null) InfoRow(label: "نوع الحافلة", value: busData.busType!),
          if (busData.modelYear != null) InfoRow(label: "موديل", value: busData.modelYear!),
          if (busData.sectionName != null) InfoRow(label: "القسم", value: busData.sectionName!),
          if (busData.accountName != null) InfoRow(label: "الحساب", value: busData.accountName!),
          InfoRow(label: AppLocalKay.speed.tr(), value: busData.speed),
          InfoRow(
            label: AppLocalKay.passengers.tr(),
            value: "${busData.occupiedSeats}/${busData.capacity}",
          ),
        ],
      ),
    );
  }
}
