import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class LessonCard extends StatelessWidget {
  final lesson;

  const LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.lesson,
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          if (lesson.notes != null && lesson.notes!.isNotEmpty) ...[
            Gap(6.h),
            Text(
              lesson.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
            ),
          ],
          Gap(12.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              Gap(6.w),
              Text(lesson.lessonDate, style: AppTextStyle.bodySmall(context)),
            ],
          ),
        ],
      ),
    );
  }
}
