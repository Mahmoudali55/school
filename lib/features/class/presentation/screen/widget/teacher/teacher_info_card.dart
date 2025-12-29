import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class TeacherInfoCard extends StatelessWidget {
  final TeacherInfo teacherInfo;

  const TeacherInfoCard({super.key, required this.teacherInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Teacher Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green[100],
              child: Icon(Icons.person, size: 30, color: Colors.green[700]),
            ),
            const SizedBox(width: 16),
            // Teacher Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherInfo.name,
                    style: AppTextStyle.titleMedium(
                      context,
                      color: AppColor.secondAppColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacherInfo.subject,
                    style: AppTextStyle.bodyMedium(context, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teacherInfo.email,
                          style: AppTextStyle.bodyMedium(context, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
