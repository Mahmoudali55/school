import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherDataModel teacher;
  const TeacherCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.deepOrange,
      Colors.indigo,
      Colors.green,
      Colors.pink,
    ];
    final avatarColor = colors[teacher.teacherCode % colors.length];
    final initials = teacher.teacherNameAr.isNotEmpty
        ? teacher.teacherNameAr.trim().split(' ').take(2).map((w) => w[0]).join()
        : '?';

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColor.borderColor(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor(context).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [avatarColor, avatarColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTextStyle.titleMedium(context).copyWith(
                color: AppColor.whiteColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          Gap(14.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.teacherNameAr,
                  style: AppTextStyle.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Row(
                  children: [
                    Icon(Icons.badge_rounded,
                        size: 14.r,
                        color: AppColor.textColor(context).withValues(alpha: 0.45)),
                    Gap(4.w),
                    Text(
                      'كود: ${teacher.teacherCode}',
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.textColor(context).withValues(alpha: 0.55),
                      ),
                    ),
                    Gap(12.w),
                    Icon(Icons.menu_book_rounded,
                        size: 14.r,
                        color: AppColor.textColor(context).withValues(alpha: 0.45)),
                    Gap(4.w),
                    Text(
                      '${AppLocalKay.COURSE_CODE}'.replaceAll('{}', teacher.COURSE_CODE.toString()),
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.textColor(context).withValues(alpha: 0.55),
                      ),
                    
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arrow
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.r,
            color: AppColor.textColor(context).withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
