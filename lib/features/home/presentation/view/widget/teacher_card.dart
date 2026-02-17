import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherDataModel teacher;
  final VoidCallback? onTap;

  const TeacherCard({super.key, required this.teacher, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Avatar with Initials
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor(context),
                        AppColor.primaryColor(context).withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      teacher.teacherNameAr.trim().isNotEmpty
                          ? teacher.teacherNameAr.trim().characters.take(1).toString()
                          : "T",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                // Teacher Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.teacherNameAr,
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      Gap(4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 14.sp,
                            color: AppColor.greyColor(context),
                          ),
                          Gap(4.w),
                          Text(
                            "كود المعلم: ${teacher.teacherCode}",
                            style: AppTextStyle.bodySmall(
                              context,
                            ).copyWith(color: AppColor.greyColor(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldColor(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColor.primaryColor(context),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
