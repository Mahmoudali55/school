import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/teacher_classes_cubit.dart';

import '../../../../data/model/teacher_classes_models.dart';

class ClassCardWidget extends StatelessWidget {
  final ClassInfo classInfo;
  final VoidCallback onStudentsPressed;
  final VoidCallback onAssignmentsPressed;
  final VoidCallback onAttendancePressed;

  const ClassCardWidget({
    super.key,
    required this.classInfo,
    required this.onStudentsPressed,
    required this.onAssignmentsPressed,
    required this.onAttendancePressed,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
                  child: Text(
                    '${classInfo.studentCount} طالب',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Class Details
            _buildDetailRow(Icons.calendar_today, classInfo.schedule),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, classInfo.time),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.room, classInfo.room),

            const SizedBox(height: 12),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalKay.program.tr(),
                      style: AppTextStyle.bodyMedium(context, color: Colors.grey[600]),
                    ),
                    Text(
                      '${(classInfo.progress * 100).toInt()}%',
                      style: AppTextStyle.bodyMedium(context, color: Colors.green[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: classInfo.progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.students.tr(),
                    icon: Icons.people,
                    onPressed: onStudentsPressed,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.todostitle.tr(),
                    icon: Icons.assignment,
                    onPressed: onAssignmentsPressed,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _buildActionButton(
                    text: AppLocalKay.checkin.tr(),
                    icon: Icons.class_,
                    onPressed: onAttendancePressed,
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) => _handleMenuAction(value, context),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('تعديل')],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            AppLocalKay.dialog_delete_confirm.tr(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'add_assignment',
                      child: Row(
                        children: [
                          Icon(Icons.add_circle, size: 18),
                          SizedBox(width: 8),
                          Text(AppLocalKay.create_todo.tr()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(text, style: const TextStyle(fontSize: 10)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: BorderSide(color: Colors.green!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleMenuAction(String value, BuildContext context) {
    switch (value) {
      case 'edit':
        _showEditClassDialog(context);
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
      case 'add_assignment':
        context.read<TeacherClassesCubit>().addAssignment(classInfo.id);
        break;
    }
  }

  void _showEditClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الفصل'),
        content: const Text('هنا يمكن تعديل معلومات الفصل...'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              // TODO: تحديث معلومات الفصل
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفصل'),
        content: Text('هل تريد حذف ${classInfo.className}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              context.read<TeacherClassesCubit>().deleteClass(classInfo.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
