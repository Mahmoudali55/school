import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';

class AdminClassesStats extends StatelessWidget {
  final List<SchoolClass> classes;

  const AdminClassesStats({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    final totalStudents = classes.fold(0, (sum, classItem) => sum + classItem.currentStudents);
    final totalCapacity = classes.fold(0, (sum, classItem) => sum + classItem.capacity);
    final fullClasses = classes
        .where((classItem) => classItem.currentStudents >= classItem.capacity)
        .length;
    final availableClasses = classes
        .where((classItem) => classItem.currentStudents < classItem.capacity)
        .length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, classes.length.toString(), AppLocalKay.classes.tr(), Colors.blue),
          _buildStatItem(
            context,
            totalStudents.toString(),
            AppLocalKay.students.tr(),
            Colors.green,
          ),
          _buildStatItem(
            context,
            '${totalCapacity > 0 ? ((totalStudents / totalCapacity) * 100).toStringAsFixed(1) : "0"}%',
            AppLocalKay.stats_fill_rate.tr(),
            Colors.orange,
          ),
          _buildStatItem(
            context,
            '$availableClasses/$fullClasses',
            AppLocalKay.stats_available_full.tr(),
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
