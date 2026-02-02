import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class StudentsListSheet extends StatelessWidget {
  final ClassInfo classInfo;

  const StudentsListSheet({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.blackColor(context)),
                  ),
                  child: Center(
                    child: Icon(Icons.close, color: AppColor.blackColor(context), size: 18),
                  ),
                ),
              ),
              const Spacer(),
              Text('${AppLocalKay.students.tr()} ', style: AppTextStyle.titleLarge(context)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: classInfo.studentCount.clamp(0, 10),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text('${AppLocalKay.student.tr()} '),
                  subtitle: const Text('درجة الحضور: 95%'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
