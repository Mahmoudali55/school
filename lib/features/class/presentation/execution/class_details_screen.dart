// lib/features/classes/presentation/screens/class_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/class/presentation/execution/add_edit_class_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_reports_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_schedule_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_students_screen.dart';

import '../../data/model/school_class_model.dart';

class ClassDetailsScreen extends StatelessWidget {
  final SchoolClass schoolClass;

  const ClassDetailsScreen({super.key, required this.schoolClass});

  @override
  Widget build(BuildContext context) {
    double fillPercentage = (schoolClass.currentStudents / schoolClass.capacity) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الفصل',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة المعلومات الأساسية
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schoolClass.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildDetailItem('الصف', schoolClass.grade, Icons.grade),
                    _buildDetailItem('الشعبة', schoolClass.section, Icons.category),
                    _buildDetailItem('المعلم', schoolClass.teacher, Icons.person),
                    _buildDetailItem('القاعة', schoolClass.room, Icons.room),
                    _buildDetailItem('الجدول', schoolClass.schedule, Icons.schedule),

                    SizedBox(height: 16.h),

                    // إحصائيات السعة
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'السعة',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${schoolClass.currentStudents}/${schoolClass.capacity}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: fillPercentage >= 90
                                      ? Colors.red
                                      : fillPercentage >= 70
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          LinearProgressIndicator(
                            value: schoolClass.currentStudents / schoolClass.capacity,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              fillPercentage >= 90
                                  ? Colors.red
                                  : fillPercentage >= 70
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            minHeight: 12.h,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${fillPercentage.toStringAsFixed(1)}% ممتلئ',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // إجراءات سريعة
            Text(
              'الإجراءات السريعة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),

            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.5,
              ),
              children: [
                _buildActionCard('إدارة الطلاب', Icons.people, Colors.blue, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassStudentsScreen(schoolClass: schoolClass),
                    ),
                  );
                }),
                _buildActionCard('تعديل الفصل', Icons.edit, Colors.orange, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditClassScreen(schoolClass: schoolClass),
                    ),
                  );
                }),
                _buildActionCard('جدول الحصص', Icons.calendar_today, Colors.green, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassScheduleScreen(schoolClass: schoolClass),
                    ),
                  );
                }),
                _buildActionCard('تقارير الفصل', Icons.analytics, Colors.purple, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassReportsScreen(schoolClass: schoolClass),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30.w, color: color),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
