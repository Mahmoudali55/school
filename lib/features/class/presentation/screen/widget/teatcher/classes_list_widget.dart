import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../../../data/model/teacher_classes_models.dart';
import 'class_card_widget.dart';

class ClassesListWidget extends StatelessWidget {
  final List<ClassInfo> classes;

  const ClassesListWidget({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalKay.empty_classes.tr(),
              style: AppTextStyle.titleMedium(context, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(AppLocalKay.empty_classes_hint.tr(), style: AppTextStyle.bodyMedium(context)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        return ClassCardWidget(
          classInfo: classInfo,
          onStudentsPressed: () {
            _showStudentsDialog(context, classInfo);
          },
          onAssignmentsPressed: () {
            _showAssignmentsDialog(context, classInfo);
          },
          onAttendancePressed: () {
            _showAttendanceDialog(context, classInfo);
          },
        );
      },
    );
  }

  void _showStudentsDialog(BuildContext context, ClassInfo classInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('طلاب ${classInfo.className}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: classInfo.studentCount.clamp(0, 10),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text('${index + 1}'),
                ),
                title: Text('الطالب ${index + 1}'),
                subtitle: const Text('درجة الحضور: 95%'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.dialog_delete_cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalKay.show_all.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignmentsDialog(BuildContext context, ClassInfo classInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('واجبات ${classInfo.className}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: classInfo.assignments,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text('الواجب ${index + 1}'),
                  subtitle: const Text('موعد التسليم: ٢٠ نوفمبر'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, size: 20),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
          ElevatedButton(
            onPressed: () {
              // TODO: إضافة واجب جديد
              Navigator.pop(context);
            },
            child: const Text('إضافة واجب'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context, ClassInfo classInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حضور ${classInfo.className}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('نسبة الحضور الحالية: 92%'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: تسجيل الحضور
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('تسجيل الحضور اليوم'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: عرض سجل الحضور
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('عرض سجل الحضور'),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
      ),
    );
  }
}
