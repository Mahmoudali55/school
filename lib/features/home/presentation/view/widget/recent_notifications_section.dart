import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class RecentNotificationsSection extends StatelessWidget {
  const RecentNotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      ("فعالية اليوم الوطني", "احتفال المدرسة غداً", "منذ ساعة", Colors.purple, Icons.event),
      ("إعلان مهم", "تغيير جدول الأسبوع القادم", "منذ 3 ساعات", Colors.blue, Icons.announcement),
      ("نشاط رياضي", "مسابقة كرة القدم", "منذ يوم", Colors.green, Icons.sports_soccer),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "آخر الإشعارات",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                NavigatorMethods.pushNamed(context, RoutesName.notificationsScreen);
              },
              child: Text("عرض الكل", style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          children: data.map((item) {
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
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: item.$4.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.$5, color: item.$4, size: 20.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.$2,
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.$3,
                          style: TextStyle(color: Colors.grey, fontSize: 10.sp),
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
