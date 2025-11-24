import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusStatusHeader extends StatelessWidget {
  final Map<String, dynamic> busData;
  const BusStatusHeader({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_bus_rounded, color: const Color(0xFF4CAF50), size: 24.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الحافلة ${busData['busNumber']}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                busData['status'],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            busData['estimatedTime'],
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
