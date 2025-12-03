import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Student> students = [
    Student('أحمد محمد', '1', true),
    Student('فاطمة علي', '2', true),
    Student('خالد إبراهيم', '3', false),
    Student('سارة عبدالله', '4', true),
    Student('محمد حسن', '5', false),
    Student('نورة خالد', '6', true),
  ];

  String? _selectedClass = 'الصف الأول';
  final List<String> classes = [
    'الصف الأول',
    'الصف الثاني',
    'الصف الثالث',
    'الصف الرابع',
    'الصف الخامس',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.check_in.tr(),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedClass,
                    decoration: InputDecoration(
                      labelText: AppLocalKay.user_management_class.tr(),
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
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: AppLocalKay.user_management_date.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      suffixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: AppColor.textFormFillColor(context),
                    ),
                    controller: TextEditingController(
                      text: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // إحصائيات الحضور
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  AppLocalKay.user_management_attendees.tr(),
                  '4',
                  AppColor.secondAppColor(context),
                ),
                _buildStat(
                  AppLocalKay.user_management_absent.tr(),
                  '2',
                  AppColor.errorColor(context),
                ),
                _buildStat(
                  AppLocalKay.user_management_percentage.tr(),
                  '67%',
                  AppColor.primaryColor(context),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // قائمة الطلاب
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(students[index]);
              },
            ),
          ),

          // زر الحفظ
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: AppLocalKay.user_management_save.tr(),
              radius: 12.r,
              onPressed: _saveAttendance,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
          child: Icon(
            student.isPresent ? Icons.check : Icons.close,
            color: student.isPresent ? Colors.green : Colors.red,
          ),
        ),
        title: Text(student.name),
        subtitle: Text('الرقم: ${student.id}'),
        trailing: Switch(
          value: student.isPresent,
          onChanged: (value) {
            setState(() {
              student.isPresent = value;
            });
          },
          activeColor: const Color(0xFF10B981),
        ),
      ),
    );
  }

  void _saveAttendance() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم حفظ الحضور بنجاح'), backgroundColor: Colors.green));
  }
}

class Student {
  String name;
  String id;
  bool isPresent;

  Student(this.name, this.id, this.isPresent);
}
