import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/Info_row_widget.dart';

class BusInformation extends StatelessWidget {
  final BusDataModel busData;
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
          Gap(16.h),
          InfoRow(label: AppLocalKay.driver.tr(), value: busData.driverNameAr ?? "-"),
          InfoRow(label: AppLocalKay.phone.tr(), value: "-"), // Phone not in BusDataModel
          if (busData.supervisorNameAr1 != null)
            InfoRow(label: AppLocalKay.supervisor.tr(), value: busData.supervisorNameAr1!),
          InfoRow(label: AppLocalKay.phone.tr(), value: "-"),
          if (busData.busType != null)
            InfoRow(label: AppLocalKay.bus_type.tr(), value: busData.busType!),
          if (busData.modelNo != null)
            InfoRow(label: AppLocalKay.model_year.tr(), value: busData.modelNo!),
          if (busData.sectionNameAr != null)
            InfoRow(label: AppLocalKay.section.tr(), value: busData.sectionNameAr!),
          if (busData.companyName != null)
            InfoRow(label: AppLocalKay.account.tr(), value: busData.companyName!),
          InfoRow(label: AppLocalKay.speed.tr(), value: "-"),
          InfoRow(label: AppLocalKay.passengers.tr(), value: "0/${busData.busSets ?? "-"}"),
        ],
      ),
    );
  }
}
