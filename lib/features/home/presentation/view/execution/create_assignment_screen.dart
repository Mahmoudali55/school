import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedSubject;
  String? _selectedClass;
  DateTime? _dueDate;

  List<String> subjects = [
    'الرياضيات',
    'العلوم',
    'اللغة العربية',
    'اللغة الإنجليزية',
    'الاجتماعيات',
  ];
  List<String> classes = ['الصف الأول', 'الصف الثاني', 'الصف الثالث', 'الصف الرابع', 'الصف الخامس'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          'إنشاء واجب',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('المادة', style: AppTextStyle.formTitleStyle(context)),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: InputDecoration(
                  labelText: 'المادة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: AppColor.textFormFillColor(context),
                ),
                items: subjects.map((String subject) {
                  return DropdownMenuItem<String>(value: subject, child: Text(subject));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار المادة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              Text('الصف', style: AppTextStyle.formTitleStyle(context)),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: AppColor.textFormFillColor(context),
                ),
                items: classes.map((String classItem) {
                  return DropdownMenuItem<String>(value: classItem, child: Text(classItem));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار الصف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              CustomFormField(
                controller: _titleController,
                radius: 12,
                title: 'عنوان الواجب',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان الواجب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // وصف الواجب
              CustomFormField(
                controller: _descriptionController,
                maxLines: 4,
                radius: 12,
                title: 'وصف الواجب',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف الواجب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // تاريخ التسليم
              CustomFormField(
                readOnly: true,
                radius: 12,
                title: 'تاريخ التسليم',
                suffixIcon: IconButton(icon: Icon(Icons.calendar_today), onPressed: _selectDueDate),
                controller: TextEditingController(
                  text: _dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'اختر تاريخ التسليم',
                ),
                validator: (value) {
                  if (_dueDate == null) {
                    return 'يرجى اختيار تاريخ التسليم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // رفع الملفات
              GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'mp4', 'avi'],
                  );

                  if (result != null) {
                    print("Selected File: ${result.files.single.name}");
                  } else {
                    print("User canceled");
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload, size: 40.w, color: Colors.grey),
                      SizedBox(height: 8.h),
                      Text(
                        'ارفع ملفات الواجب',
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'PDF, PPT, Word, Video',
                        style: AppTextStyle.titleSmall(
                          context,
                        ).copyWith(color: AppColor.greyColor(context)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // زر الإنشاء
              CustomButton(
                radius: 12.r,
                text: 'انشاء الواجب',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createAssignment();
                  }
                },
                color: AppColor.accentColor(context),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _createAssignment() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم إنشاء الواجب بنجاح'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
