import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

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

              // عنوان الواجب
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان الواجب',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان الواجب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // وصف الواجب
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'وصف الواجب',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(height: 16.h),

              // تاريخ التسليم
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'تاريخ التسليم',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDueDate,
                  ),
                ),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(Icons.attach_file, size: 40.w, color: Colors.grey),
                    SizedBox(height: 8.h),
                    Text('ارفق ملفات الواجب', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(height: 8.h),
                    Text(
                      'PDF, Word, Image',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // زر الإنشاء
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createAssignment();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'إنشاء الواجب',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
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
