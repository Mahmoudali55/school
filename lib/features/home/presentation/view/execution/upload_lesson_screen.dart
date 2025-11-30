import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';

class UploadLessonScreen extends StatefulWidget {
  const UploadLessonScreen({super.key});

  @override
  State<UploadLessonScreen> createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedSubject;
  String? _selectedClass;

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
          'رفع درس جديد',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // اختيار المادة
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: InputDecoration(
                  labelText: 'المادة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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

              // اختيار الصف
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: InputDecoration(
                  labelText: 'الصف',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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

              // عنوان الدرس
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان الدرس',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان الدرس';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // وصف الدرس
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'وصف الدرس',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(height: 16.h),

              // رفع الملف
              Container(
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
                    Text('ارفع ملفات الدرس', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(height: 8.h),
                    Text(
                      'PDF, PPT, Word, Video',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // زر الرفع
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _uploadLesson();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'رفع الدرس',
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

  void _uploadLesson() {
    // هنا سيتم رفع الدرس
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم رفع الدرس بنجاح'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
