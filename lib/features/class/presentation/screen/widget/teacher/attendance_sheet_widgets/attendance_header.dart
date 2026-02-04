import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class AttendanceHeader extends StatelessWidget {
  final ClassInfo classInfo;

  const AttendanceHeader({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.absent_from_class.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: AppColor.primaryColor(context),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  classInfo.className,
                  style: AppTextStyle.headlineSmall(context).copyWith(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.primaryColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: AppColor.primaryColor(context),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
