import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class StudentClassCard extends StatelessWidget {
  final String className;
  final String teacherName;
  final String room;
  final String time;
  final Color color;
  final IconData icon;
  final VoidCallback onEnter;

  const StudentClassCard({
    super.key,
    required this.className,
    required this.teacherName,
    required this.room,
    required this.time,
    required this.color,
    required this.icon,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            // Class Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: AppTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  _buildIconText(context, Icons.person, teacherName),
                  const SizedBox(height: 4),
                  _buildIconText(context, Icons.room, room),
                  const SizedBox(height: 4),
                  _buildIconText(context, Icons.access_time, time),
                ],
              ),
            ),
            // Enter Class Button
            Container(
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                onPressed: onEnter,
                icon: Icon(Icons.arrow_forward, color: AppColor.whiteColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
