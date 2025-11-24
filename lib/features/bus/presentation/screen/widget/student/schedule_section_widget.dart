import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleSection extends StatelessWidget {
  final List<Map<String, dynamic>> schedule;

  const ScheduleSection({super.key, required this.schedule});

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
            "جدول الحافلة",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          ...schedule.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['period'], style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${item['pickup']} → ${item['arrival']}"),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
