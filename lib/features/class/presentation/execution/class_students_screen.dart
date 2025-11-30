// lib/features/classes/presentation/screens/class_students_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
      appBar: AppBar(
        title: Text(
          'طلاب ${widget.schoolClass.name}',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.person_add), onPressed: _addStudent)],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن طالب...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
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
          _buildStatItem(_students.length.toString(), 'الطلاب', Colors.blue),
          _buildStatItem('5', 'حاضرون', Colors.green),
          _buildStatItem('0', 'غائبون', Colors.red),
          _buildStatItem('85%', 'الحضور', Colors.orange),
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
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
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
        title: Text(
          student.name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الرقم الأكاديمي: ${student.academicId}'),
            Text('ولي الأمر: ${student.parentName}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) => _handleStudentAction(value, student),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'attendance', child: Text('سجل الحضور')),
            PopupMenuItem(value: 'transfer', child: Text('نقل إلى فصل آخر')),
            PopupMenuItem(
              value: 'delete',
              child: Text('حذف', style: TextStyle(color: Colors.red)),
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
          title: Text('نقل الطالب'),
          content: Text('هل تريد نقل الطالب ${student.name} إلى فصل آخر؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: تنفيذ نقل الطالب
              },
              child: Text('نقل'),
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
          title: Text('حذف الطالب'),
          content: Text('هل أنت متأكد من أنك تريد حذف الطالب ${student.name}؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
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
              child: Text('حذف', style: TextStyle(color: Colors.red)),
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
