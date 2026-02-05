import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class TeacherClassCard extends StatelessWidget {
  final ClassInfo classInfo;
  final VoidCallback onStudentsPressed;
  final VoidCallback onAssignmentsPressed;
  final VoidCallback onAttendancePressed;
  final VoidCallback onLessonsPressed;

  const TeacherClassCard({
    super.key,
    required this.classInfo,
    required this.onStudentsPressed,
    required this.onAssignmentsPressed,
    required this.onAttendancePressed,
    required this.onLessonsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    classInfo.className,
                    style: AppTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${classInfo.studentCount} ${AppLocalKay.student.tr()}',
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: Colors.green[700], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${AppLocalKay.code.tr()}: ${classInfo.id}',
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
            ),
            // Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.students.tr(),
                    onPressed: onStudentsPressed,
                    context: context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.todostitle.tr(),
                    onPressed: onAssignmentsPressed,
                    context: context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.absence.tr(),
                    onPressed: onAttendancePressed,
                    context: context,
                  ),
                ),
              ],
            ),
            Gap(8.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.lessons.tr(),
                    onPressed: onLessonsPressed,
                    context: context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: const BorderSide(color: Colors.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: AppTextStyle.bodySmall(context).copyWith(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
