// lib/features/classes/presentation/screens/add_edit_class_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
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
      appBar: AppBar(
        title: Text(
          widget.schoolClass == null ? 'إضافة فصل جديد' : 'تعديل الفصل',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveClass)],
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
                title: 'اسم الفصل',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الفصل';
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
                      title: 'الصف',
                      prefixIcon: Icon(Icons.grade),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الصف';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomFormField(
                      controller: _sectionController,
                      title: 'الشعبة',
                      prefixIcon: Icon(Icons.category),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الشعبة';
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
                      title: 'السعة',

                      prefixIcon: Icon(Icons.people),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال السعة';
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
                      title: 'الطلاب الحاليين',

                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال عدد الطلاب';
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
                title: 'المعلم',

                prefixIcon: Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المعلم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // القاعة
              CustomFormField(
                controller: _roomController,
                title: 'القاعة',

                prefixIcon: Icon(Icons.room),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم القاعة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // الجدول
              CustomFormField(
                controller: _scheduleController,
                title: 'الجدول',

                prefixIcon: Icon(Icons.schedule),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الجدول';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _saveClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    widget.schoolClass == null ? 'إضافة الفصل' : 'حفظ التغييرات',
                    style: TextStyle(fontSize: 16.sp, color: AppColor.whiteColor(context)),
                  ),
                ),
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
