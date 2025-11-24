import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafetyAlertsWidget extends StatelessWidget {
  final List<String> alerts;

  const SafetyAlertsWidget({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تنبيهات السلامة",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 8.h),
          ...alerts.map(
            (alert) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20.w),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(alert, style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
