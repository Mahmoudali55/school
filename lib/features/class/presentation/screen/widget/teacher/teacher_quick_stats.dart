import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class TeacherQuickStats extends StatelessWidget {
  final ClassStats stats;

  const TeacherQuickStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          width: 0.22.sw,
          child: _buildStatCard(
            context: context,
            title: AppLocalKay.studentstitle.tr(),
            value: '${stats.totalStudents}',
            icon: Icons.people,
            color: AppColor.primaryColor(context),
          ),
        ),
        SizedBox(
          width: 0.22.sw,
          child: _buildStatCard(
            context: context,
            title: AppLocalKay.todostitle.tr(),
            value: '${stats.totalAssignments}',
            icon: Icons.assignment,
            color: AppColor.accentColor(context),
          ),
        ),
        SizedBox(
          width: 0.22.sw,
          child: _buildStatCard(
            context: context,
            title: AppLocalKay.user_management_upload_lesson.tr(),
            value: '${stats.totalLessons}',
            icon: Icons.book,
            color: Colors.orange,
          ),
        ),
        SizedBox(
          width: 0.22.sw,
          child: _buildStatCard(
            context: context,
            title: AppLocalKay.checkintitle.tr(),
            value: '${(stats.attendanceRate * 100).toInt()}%',
            icon: Icons.check,
            color: AppColor.secondAppColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            Text(
              value,
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
