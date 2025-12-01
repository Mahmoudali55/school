import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class QuickOverviewWidget extends StatelessWidget {
  const QuickOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _overviewItem("السائق", "أحمد علي", Icons.person),
          _overviewItem("الطلاب", "35 طالب", Icons.school),
          _overviewItem("الرحلة", "15 دقيقة", Icons.timer),
        ],
      ),
    );
  }

  Widget _overviewItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.purple, size: 28.w),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
