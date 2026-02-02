import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class AttendanceSheet extends StatelessWidget {
  final ClassInfo classInfo;

  const AttendanceSheet({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('حضور ${classInfo.className}', style: AppTextStyle.titleLarge(context)),
          const SizedBox(height: 16),
          const Text('نسبة الحضور الحالية: 92%'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
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
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('عرض سجل الحضور'),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }
}
