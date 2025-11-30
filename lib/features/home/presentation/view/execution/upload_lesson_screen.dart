import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المادة', style: AppTextStyle.formTitle20Style(context)),
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: InputDecoration(
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

                Text('الصف', style: AppTextStyle.formTitle20Style(context)),
                // اختيار الصف
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

                // عنوان الدرس
                CustomFormField(
                  controller: _titleController,
                  title: 'عنوان الدرس',
                  radius: 12.r,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان الدرس';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // وصف الدرس
                CustomFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  title: 'وصف الدرس',
                  radius: 12.r,
                ),
                SizedBox(height: 16.h),

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
                          'ارفع ملفات الدرس',
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

                CustomButton(
                  text: 'رفع الدرس',
                  radius: 12.r,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _uploadLesson();
                    }
                  },
                ),
              ],
            ),
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
