// features/class/presentation/execution/class_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';

class ClassReportsScreen extends StatefulWidget {
  final SchoolClass schoolClass;

  const ClassReportsScreen({super.key, required this.schoolClass});

  @override
  State<ClassReportsScreen> createState() => _ClassReportsScreenState();
}

class _ClassReportsScreenState extends State<ClassReportsScreen> {
  int _selectedReportType = 0;

  final List<Map<String, dynamic>> _reportTypes = [
    {'title': 'تقرير الحضور', 'icon': Icons.calendar_today, 'color': Colors.blue},
    {'title': 'تقرير الدرجات', 'icon': Icons.grade, 'color': Colors.green},
    {'title': 'تقرير السلوك', 'icon': Icons.psychology, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تقارير ${widget.schoolClass.name}',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // أنواع التقارير
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.assessment, size: 24.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  'اختر نوع التقرير:',
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _reportTypes.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                final report = _reportTypes[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
                  child: ChoiceChip(
                    label: Text(report['title']),
                    avatar: Icon(
                      report['icon'],
                      size: 18.w,
                      color: _selectedReportType == index
                          ? AppColor.whiteColor(context)
                          : report['color'],
                    ),
                    selected: _selectedReportType == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedReportType = index;
                      });
                    },
                    selectedColor: report['color'],
                    labelStyle: AppTextStyle.titleSmall(context).copyWith(
                      color: _selectedReportType == index
                          ? AppColor.whiteColor(context)
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16.h),

          // إحصائيات سريعة
          _buildQuickStats(),
          SizedBox(height: 16.h),

          // التقرير المحدد
          Expanded(child: _buildSelectedReport()),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('الحضور', '94%', Icons.trending_up, Colors.green)),
          SizedBox(width: 12.w),
          Expanded(child: _buildStatCard('المتوسط', '86%', Icons.grade, Colors.blue)),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'الطلاب',
              '${widget.schoolClass.currentStudents}',
              Icons.people,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20.w),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedReport() {
    switch (_selectedReportType) {
      case 0:
        return _buildAttendanceReport();
      case 1:
        return _buildGradesReport();
      case 2:
        return _buildBehaviorReport();
      default:
        return _buildAttendanceReport();
    }
  }

  Widget _buildAttendanceReport() {
    final attendanceData = [
      {'student': 'محمد أحمد', 'present': 18, 'absent': 2, 'percentage': '90%'},
      {'student': 'فاطمة خالد', 'present': 19, 'absent': 1, 'percentage': '95%'},
      {'student': 'علي محمد', 'present': 17, 'absent': 3, 'percentage': '85%'},
      {'student': 'سارة عبدالله', 'present': 20, 'absent': 0, 'percentage': '100%'},
      {'student': 'خالد إبراهيم', 'present': 16, 'absent': 4, 'percentage': '80%'},
    ];

    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقرير الحضور - آخر 20 يوم',
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  final student = attendanceData[index];
                  return _buildAttendanceRow(student, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(Map<String, dynamic> student, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              '${index + 1}',
              style: AppTextStyle.titleSmall(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['student'],
                  style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  'حضور: ${student['present']} | غياب: ${student['absent']}',
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getPercentageColor(student['percentage']),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              student['percentage'],
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesReport() {
    final gradesData = [
      {'subject': 'الرياضيات', 'average': '92%', 'highest': '100%', 'lowest': '85%'},
      {'subject': 'اللغة العربية', 'average': '88%', 'highest': '95%', 'lowest': '78%'},
      {'subject': 'العلوم', 'average': '85%', 'highest': '92%', 'lowest': '75%'},
      {'subject': 'اللغة الإنجليزية', 'average': '90%', 'highest': '98%', 'lowest': '82%'},
      {'subject': 'التربية الإسلامية', 'average': '94%', 'highest': '100%', 'lowest': '88%'},
    ];

    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقرير الدرجات - الفصل الأول',
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: gradesData.length,
                itemBuilder: (context, index) {
                  final subject = gradesData[index];
                  return _buildGradeRow(subject, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeRow(Map<String, dynamic> subject, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.grade, size: 20.w, color: Colors.green),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject['subject'],
                  style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  'أعلى: ${subject['highest']} | أدنى: ${subject['lowest']}',
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                subject['average'],
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(
                'المتوسط',
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontSize: 10.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorReport() {
    final behaviorData = [
      {'student': 'محمد أحمد', 'points': 95, 'status': 'متميز'},
      {'student': 'فاطمة خالد', 'points': 98, 'status': 'متميز'},
      {'student': 'علي محمد', 'points': 85, 'status': 'جيد جداً'},
      {'student': 'سارة عبدالله', 'points': 92, 'status': 'متميز'},
      {'student': 'خالد إبراهيم', 'points': 78, 'status': 'جيد'},
    ];

    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقرير السلوك - الشهر الحالي',
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: behaviorData.length,
                itemBuilder: (context, index) {
                  final student = behaviorData[index];
                  return _buildBehaviorRow(student, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorRow(Map<String, dynamic> student, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: _getBehaviorColor(student['points']),
            child: Icon(
              _getBehaviorIcon(student['points']),
              size: 18.w,
              color: AppColor.whiteColor(context),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['student'],
                  style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${student['points']} نقطة',
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getBehaviorColor(student['points']),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              student['status'],
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(String percentage) {
    final value = int.parse(percentage.replaceAll('%', ''));
    if (value >= 90) return Colors.green;
    if (value >= 80) return Colors.blue;
    if (value >= 70) return Colors.orange;
    return Colors.red;
  }

  Color _getBehaviorColor(int points) {
    if (points >= 90) return Colors.green;
    if (points >= 80) return Colors.blue;
    if (points >= 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getBehaviorIcon(int points) {
    if (points >= 90) return Icons.emoji_events;
    if (points >= 80) return Icons.thumb_up;
    if (points >= 70) return Icons.sentiment_satisfied;
    return Icons.sentiment_dissatisfied;
  }
}
