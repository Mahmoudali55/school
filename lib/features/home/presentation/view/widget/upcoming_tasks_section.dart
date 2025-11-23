import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingTasksSection extends StatelessWidget {
  const UpcomingTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ("حل تمارين الرياضيات", "الرياضيات", "غداً", Colors.red),
      ("بحث عن النظام الشمسي", "العلوم", "بعد ٣ أيام", Colors.orange),
      ("اختبار الوحدة الثانية", "العربية", "الأسبوع القادم", Colors.green),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ما يجب عليك فعله",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Column(
          children: tasks.map((task) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: task.$4.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.assignment, color: task.$4, size: 20.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.$1,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              task.$2,
                              style: TextStyle(color: Colors.blue, fontSize: 11.sp),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.calendar_today, size: 12.w, color: Colors.grey),
                            SizedBox(width: 4.w),
                            Text(
                              task.$3,
                              style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
