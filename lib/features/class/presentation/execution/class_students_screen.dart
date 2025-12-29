// lib/features/classes/presentation/screens/class_students_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../data/model/school_class_model.dart';

class ClassStudentsScreen extends StatefulWidget {
  final SchoolClass schoolClass;

  const ClassStudentsScreen({super.key, required this.schoolClass});

  @override
  State<ClassStudentsScreen> createState() => _ClassStudentsScreenState();
}

class _ClassStudentsScreenState extends State<ClassStudentsScreen> {
  final List<Student> _students = [
    Student('1', 'أحمد محمد', '123456', '01012345678', 'أحمد محمود'),
    Student('2', 'فاطمة علي', '123457', '01012345679', 'علي إبراهيم'),
    Student('3', 'خالد سعيد', '123458', '01012345680', 'سعيد حسن'),
    Student('4', 'سارة عبدالله', '123459', '01012345681', 'عبدالله محمد'),
    Student('5', 'محمد خالد', '123460', '01012345682', 'خالد أحمد'),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Student> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          '${AppLocalKay.btn_students.tr()} ${widget.schoolClass.name}',
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomFormField(
              radius: 12.r,
              controller: _searchController,
              hintText: context.locale.languageCode == 'ar'
                  ? 'ابحث عن طالب...'
                  : 'Search for a student...',
              prefixIcon: Icon(Icons.search),
              onChanged: _onSearchChanged,
            ),
          ),

          // إحصائيات
          _buildStudentStats(),

          // قائمة الطلاب
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(_filteredStudents[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        backgroundColor: const Color(0xFF2E5BFF),
        child: Icon(Icons.person_add, color: AppColor.whiteColor(context)),
      ),
    );
  }

  Widget _buildStudentStats() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(_students.length.toString(), AppLocalKay.btn_students.tr(), Colors.blue),
          _buildStatItem('5', AppLocalKay.user_management_attendees.tr(), Colors.green),
          _buildStatItem('0', AppLocalKay.user_management_absent.tr(), Colors.red),
          _buildStatItem('85%', AppLocalKay.checkin.tr(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color),
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

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E5BFF).withOpacity(0.1),
          child: Icon(Icons.person, color: const Color(0xFF2E5BFF)),
        ),
        title: Text(student.name, style: AppTextStyle.headlineSmall(context)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' ${AppLocalKay.academic_number.tr()}: ${student.academicId}'),
            Text(' ${AppLocalKay.parent.tr()} ${student.parentName}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) => _handleStudentAction(value, student),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(
                AppLocalKay.user_management_edit.tr(),
                style: AppTextStyle.bodyMedium(context),
              ),
            ),
            PopupMenuItem(
              value: 'attendance',
              child: Text(AppLocalKay.check_record.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
            PopupMenuItem(
              value: 'transfer',
              child: Text(
                AppLocalKay.next_class_desc.tr(),
                style: AppTextStyle.bodyMedium(context),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                AppLocalKay.user_management_delete.tr(),
                style: AppTextStyle.bodyMedium(context, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((student) {
          return student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.academicId.contains(query) ||
              student.parentName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _addStudent() {
    // TODO: إضافة طالب جديد
  }

  void _handleStudentAction(String action, Student student) {
    switch (action) {
      case 'edit':
        _editStudent(student);
        break;
      case 'attendance':
        _viewAttendance(student);
        break;
      case 'transfer':
        _transferStudent(student);
        break;
      case 'delete':
        _deleteStudent(student);
        break;
    }
  }

  void _editStudent(Student student) {
    // TODO: تعديل بيانات الطالب
  }

  void _viewAttendance(Student student) {
    // TODO: عرض سجل الحضور
  }

  void _transferStudent(Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalKay.student_transfer.tr(), style: AppTextStyle.bodyMedium(context)),
          content: Text(
            '${AppLocalKay.student_transfer_desc.tr()}${student.name} ${AppLocalKay.next_class_title.tr()}؟',
            style: AppTextStyle.bodyMedium(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: تنفيذ نقل الطالب
              },
              child: Text(AppLocalKay.transfer.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
          ],
        );
      },
    );
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalKay.delete_student.tr(), style: AppTextStyle.bodyMedium(context)),
          content: Text(
            '${AppLocalKay.delete_student_desc.tr()}${student.name}؟',
            style: AppTextStyle.bodyMedium(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _students.remove(student);
                  _filteredStudents.remove(student);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف الطالب بنجاح'), backgroundColor: Colors.green),
                );
              },
              child: Text(
                AppLocalKay.delete.tr(),
                style: AppTextStyle.bodyMedium(context, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Student {
  final String id;
  final String name;
  final String academicId;
  final String phone;
  final String parentName;

  Student(this.id, this.name, this.academicId, this.phone, this.parentName);
}
