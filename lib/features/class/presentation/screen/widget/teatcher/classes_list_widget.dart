import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/execution/create_assignment_screen.dart';

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
            _showStudentsSheet(context, classInfo);
          },
          onAssignmentsPressed: () {
            _showAssignmentsSheet(context, classInfo);
          },
          onAttendancePressed: () {
            _showAttendanceSheet(context, classInfo);
          },
        );
      },
    );
  }

  void _showStudentsSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                        border: Border.all(color: Colors.black),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Icon(Icons.close, color: Colors.black)],
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
      },
    );
  }

  void _showAssignmentsSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: const Icon(Icons.close, size: 18),
                          ),
                        ),
                        const Spacer(),
                        Text(AppLocalKay.tasks.tr(), style: AppTextStyle.titleLarge(context)),
                        const Spacer(),
                        const SizedBox(width: 32), // موازنة المكان
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ---- List ----
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: classInfo.assignments,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange[100],
                                child: Text('${index + 1}'),
                              ),
                              title: Text('الواجب ${index + 1}'),
                              subtitle: const Text('موعد التسليم: ٢٠ نوفمبر'),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ---- Buttons ----
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateAssignmentScreen()),
                              );
                            },
                            text: AppLocalKay.create_new_assignment.tr(),
                            radius: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: AppLocalKay.cancel.tr(),
                            radius: 12,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAttendanceSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
      },
    );
  }
}
