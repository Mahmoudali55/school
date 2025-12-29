// lib/features/settings/presentation/screens/class_management_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final List<SchoolClass> _classes = [
    SchoolClass('الصف الأول', 'أ', 25, 'فاطمة علي'),
    SchoolClass('الصف الثاني', 'ب', 30, 'خالد إبراهيم'),
    SchoolClass('الصف الثالث', 'أ', 28, 'سارة عبدالله'),
    SchoolClass('الصف الرابع', 'ج', 22, 'محمد حسن'),
    SchoolClass('الصف الخامس', 'أ', 26, 'نورة خالد'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.manage_classes.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addNewClass)],
      ),
      body: Column(
        children: [
          // إحصائيات
          _buildClassStats(),

          // قائمة الصفوف
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                return _buildClassCard(_classes[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewClass,
        backgroundColor: const Color(0xFF2E5BFF),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildClassStats() {
    final totalStudents = _classes.fold(0, (sum, classItem) => sum + classItem.studentCount);
    final totalClasses = _classes.length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(totalClasses.toString(), AppLocalKay.classes.tr(), Colors.blue),
          _buildStatItem(totalStudents.toString(), AppLocalKay.students.tr(), Colors.green),
          _buildStatItem('5', AppLocalKay.teachers.tr(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: AppTextStyle.labelSmall(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildClassCard(SchoolClass schoolClass) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E5BFF).withOpacity(0.1),
          child: Icon(Icons.class_, color: const Color(0xFF2E5BFF)),
        ),
        title: Text(
          '${schoolClass.grade} - ${schoolClass.section}',
          style: AppTextStyle.headlineSmall(context),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المعلم: ${schoolClass.teacher}'),
            Text('عدد الطلاب: ${schoolClass.studentCount}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 20.w),
              onPressed: () => _editClass(schoolClass),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20.w, color: Colors.red),
              onPressed: () => _deleteClass(schoolClass),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewClass() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500.h,
          child: AddClassDialog(
            onClassAdded: (newClass) {
              setState(() {
                _classes.add(newClass);
              });
            },
          ),
        );
      },
    );
  }

  void _editClass(SchoolClass schoolClass) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500.h,
          child: EditClassDialog(
            schoolClass: schoolClass,
            onClassUpdated: (updatedClass) {
              setState(() {
                final index = _classes.indexOf(schoolClass);
                _classes[index] = updatedClass;
              });
            },
          ),
        );
      },
    );
  }

  void _deleteClass(SchoolClass schoolClass) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalKay.delete_class.tr(), style: AppTextStyle.bodyMedium(context)),
          content: Text(
            '${AppLocalKay.delete_class_content.tr()}${schoolClass.grade} - ${schoolClass.section}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _classes.remove(schoolClass);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف الصف بنجاح'), backgroundColor: Colors.green),
                );
              },
              child: Text(
                AppLocalKay.dialog_delete_confirm.tr(),
                style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SchoolClass {
  String grade;
  String section;
  int studentCount;
  String teacher;

  SchoolClass(this.grade, this.section, this.studentCount, this.teacher);
}

// ديالوج إضافة صف
class AddClassDialog extends StatefulWidget {
  final Function(SchoolClass) onClassAdded;

  const AddClassDialog({super.key, required this.onClassAdded});

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _teacherController = TextEditingController();
  final _studentCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            Center(
              child: Text(
                AppLocalKay.add_class.tr(),
                style: AppTextStyle.formTitle20Style(context),
              ),
            ),
            SizedBox(height: 16.h),
            CustomFormField(
              radius: 12.r,
              controller: _gradeController,
              title: AppLocalKay.class_added.tr(),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalKay.enter_student_count.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomFormField(
              radius: 12.r,
              controller: _sectionController,
              title: AppLocalKay.section.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalKay.enter_section.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomFormField(
              radius: 12.r,
              controller: _teacherController,
              title: AppLocalKay.teacher.tr(),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalKay.enter_teacher_name.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomFormField(
              radius: 12.r,
              controller: _studentCountController,
              title: AppLocalKay.student_count.tr(),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalKay.enter_student_count.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppLocalKay.cancel.tr(),
                    radius: 12.r,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    radius: 12.r,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newClass = SchoolClass(
                          _gradeController.text,
                          _sectionController.text,
                          int.parse(_studentCountController.text),
                          _teacherController.text,
                        );
                        widget.onClassAdded(newClass);
                        Navigator.of(context).pop();
                      }
                    },
                    text: AppLocalKay.add.tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ديالوج تعديل الصف
class EditClassDialog extends StatefulWidget {
  final SchoolClass schoolClass;
  final Function(SchoolClass) onClassUpdated;

  const EditClassDialog({super.key, required this.schoolClass, required this.onClassUpdated});

  @override
  State<EditClassDialog> createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _gradeController;
  late TextEditingController _sectionController;
  late TextEditingController _teacherController;
  late TextEditingController _studentCountController;

  @override
  void initState() {
    super.initState();
    _gradeController = TextEditingController(text: widget.schoolClass.grade);
    _sectionController = TextEditingController(text: widget.schoolClass.section);
    _teacherController = TextEditingController(text: widget.schoolClass.teacher);
    _studentCountController = TextEditingController(
      text: widget.schoolClass.studentCount.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
          Text(AppLocalKay.edit_class.tr(), style: AppTextStyle.formTitle20Style(context)),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFormField(
                  radius: 12.r,
                  controller: _gradeController,
                  title: AppLocalKay.classes_title.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalKay.enter_class_name.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomFormField(
                  radius: 12.r,
                  controller: _sectionController,
                  title: AppLocalKay.section.tr(),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalKay.enter_section.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomFormField(
                  radius: 12.r,
                  controller: _teacherController,
                  title: AppLocalKay.teacher.tr(),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalKay.enter_teacher_name.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomFormField(
                  radius: 12.r,
                  controller: _studentCountController,
                  title: AppLocalKay.student_count.tr(),

                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalKay.enter_student_count.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () => Navigator.of(context).pop(),
                        text: AppLocalKay.cancel.tr(),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: AppLocalKay.save.tr(),
                        radius: 12.r,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedClass = SchoolClass(
                              _gradeController.text,
                              _sectionController.text,
                              int.parse(_studentCountController.text),
                              _teacherController.text,
                            );
                            widget.onClassUpdated(updatedClass);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
