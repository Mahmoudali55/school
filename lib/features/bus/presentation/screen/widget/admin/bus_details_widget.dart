import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> selectedBusData;

  const BusDetailsWidget({super.key, required this.selectedBusData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل الحافلة",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          _detailRow("رقم الحافلة", selectedBusData['busNumber']),
          _detailRow("السائق", selectedBusData['driverName']),
          _detailRow("عدد الطلاب", selectedBusData['studentsCount'].toString()),
          _detailRow("المسار", selectedBusData['routeName']),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
