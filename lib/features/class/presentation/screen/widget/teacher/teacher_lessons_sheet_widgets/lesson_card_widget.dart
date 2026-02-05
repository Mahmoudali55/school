import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/attachment_button_widget.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/info_chip.dart';

class LessonCard extends StatelessWidget {
  final lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title
          Text(
            lesson.lesson,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w600),
          ),

          /// 🔹 Notes
          if (lesson.notes != null && lesson.notes!.isNotEmpty) ...[
            Gap(8.h),
            Text(
              lesson.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600], height: 1.4),
            ),
          ],

          Gap(14.h),
          Divider(height: 1, color: Colors.grey.shade200),
          Gap(10.h),

          /// 🔹 Bottom row
          Row(
            children: [
              /// Date
              InfoChip(icon: Icons.calendar_today_rounded, label: lesson.lessonDate),

              const Spacer(),

              /// Attachment Button
              AttachmentButton(lessonPath: lesson.lessonPath),
            ],
          ),
        ],
      ),
    );
  }
}
