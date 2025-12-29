// lib/features/classes/presentation/screens/add_edit_class_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';

class AddEditClassScreen extends StatefulWidget {
  final SchoolClass? schoolClass;

  const AddEditClassScreen({super.key, this.schoolClass});

  @override
  State<AddEditClassScreen> createState() => _AddEditClassScreenState();
}

class _AddEditClassScreenState extends State<AddEditClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _currentStudentsController = TextEditingController();
  final _teacherController = TextEditingController();
  final _roomController = TextEditingController();
  final _scheduleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.schoolClass != null) {
      _nameController.text = widget.schoolClass!.name;
      _gradeController.text = widget.schoolClass!.grade;
      _sectionController.text = widget.schoolClass!.section;
      _capacityController.text = widget.schoolClass!.capacity.toString();
      _currentStudentsController.text = widget.schoolClass!.currentStudents.toString();
      _teacherController.text = widget.schoolClass!.teacher;
      _roomController.text = widget.schoolClass!.room;
      _scheduleController.text = widget.schoolClass!.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          widget.schoolClass == null ? AppLocalKay.add_class.tr() : AppLocalKay.edit_class.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // اسم الفصل
              CustomFormField(
                controller: _nameController,
                prefixIcon: Icon(Icons.class_),
                title: AppLocalKay.class_name.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_name.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // الصف والشعبة
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: _gradeController,
                      title: AppLocalKay.user_management_class.tr(),
                      prefixIcon: Icon(Icons.grade),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalKay.enter_class_name.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomFormField(
                      controller: _sectionController,
                      title: AppLocalKay.section.tr(),
                      prefixIcon: Icon(Icons.category),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalKay.enter_section.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // السعة والطلاب الحاليين
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      title: AppLocalKay.label_capacity.tr(),

                      prefixIcon: Icon(Icons.people),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalKay.enter_capacity.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomFormField(
                      controller: _currentStudentsController,
                      keyboardType: TextInputType.number,
                      title: AppLocalKay.current_students.tr(),

                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalKay.enter_current_students.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // المعلم
              CustomFormField(
                controller: _teacherController,
                title: AppLocalKay.teacher.tr(),

                prefixIcon: Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_teacher.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // القاعة
              CustomFormField(
                controller: _roomController,
                title: AppLocalKay.label_room.tr(),

                prefixIcon: Icon(Icons.room),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_room.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // الجدول
              CustomFormField(
                controller: _scheduleController,
                title: AppLocalKay.label_schedule.tr(),

                prefixIcon: Icon(Icons.schedule),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_schedule.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // زر الحفظ
              CustomButton(
                radius: 12.r,
                child: Text(
                  widget.schoolClass == null ? AppLocalKay.add.tr() : AppLocalKay.save_changes.tr(),
                  style: AppTextStyle.titleMedium(context, color: AppColor.whiteColor(context)),
                ),
                color: Color(0xFF9C27B0),
                onPressed: _saveClass,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveClass() {
    if (_formKey.currentState!.validate()) {
      final newClass = SchoolClass(
        id: widget.schoolClass?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        grade: _gradeController.text,
        section: _sectionController.text,
        capacity: int.parse(_capacityController.text),
        currentStudents: int.parse(_currentStudentsController.text),
        teacher: _teacherController.text,
        room: _roomController.text,
        schedule: _scheduleController.text,
      );

      Navigator.pop(context, newClass);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _sectionController.dispose();
    _capacityController.dispose();
    _currentStudentsController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }
}
