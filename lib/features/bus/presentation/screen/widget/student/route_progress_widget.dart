import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteProgress extends StatelessWidget {
  final List<Map<String, dynamic>> stops;

  const RouteProgress({super.key, required this.stops});

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
            "مسار الرحلة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          ...stops.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> stop = entry.value;
            bool isLast = index == stops.length - 1;
            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: stop['current']
                              ? const Color(0xFF4CAF50)
                              : stop['passed']
                              ? const Color(0xFF4CAF50).withOpacity(0.5)
                              : const Color(0xFFE5E7EB),
                          shape: BoxShape.circle,
                        ),
                        child: stop['current']
                            ? Icon(Icons.directions_bus_rounded, size: 12.w, color: Colors.white)
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2.w,
                          height: 40.h,
                          color: stop['passed'] ? const Color(0xFF4CAF50) : const Color(0xFFE5E7EB),
                        ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop['name'],
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          stop['time'],
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
