import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassStatsWidget extends StatelessWidget {
  final int totalClasses;
  final int totalStudents;
  final int teacherCount;

  const ClassStatsWidget({
    super.key,
    required this.totalClasses,
    required this.totalStudents,
    required this.teacherCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(totalClasses, "الصفوف", Colors.blue),
          _statItem(totalStudents, "الطلاب", Colors.green),
          _statItem(teacherCount, "المعلمين", Colors.orange),
        ],
      ),
    );
  }

  Widget _statItem(int value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 10.sp),
        ),
      ],
    );
  }
}
