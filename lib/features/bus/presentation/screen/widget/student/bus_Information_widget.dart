import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/Info_row_widget.dart';

class BusInformation extends StatelessWidget {
  final Map<String, dynamic> busData;
  const BusInformation({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "معلومات الحافلة",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          InfoRow(label: "السائق", value: busData['driverName']),
          InfoRow(label: "الهاتف", value: busData['driverPhone']),
          InfoRow(label: "الموقع الحالي", value: busData['currentLocation']),
          InfoRow(label: "السرعة", value: busData['speed']),
          InfoRow(label: "الركاب", value: "${busData['occupiedSeats']}/${busData['capacity']}"),
        ],
      ),
    );
  }
}
