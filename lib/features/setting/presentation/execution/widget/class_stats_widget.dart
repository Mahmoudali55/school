import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
        color: AppColor.grey50Color(context),
        border: Border(bottom: BorderSide(color: AppColor.grey300Color(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(context, totalClasses, "الصفوف", AppColor.infoColor(context)),
          _statItem(context, totalStudents, "الطلاب", AppColor.successColor(context)),
          _statItem(context, teacherCount, "المعلمين", AppColor.warningColor(context)),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, int value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value.toString(),
              style: AppTextStyle.bodySmall(
                context,
                color: color,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(
            context,
            color: AppColor.greyColor(context),
          ).copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}
