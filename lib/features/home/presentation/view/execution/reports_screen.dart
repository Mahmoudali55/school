import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedTab = 0;
  String? _selectedClass = 'الصف الأول';
  String? _selectedPeriod = 'هذا الأسبوع';

  List<String> classes = ['الصف الأول', 'الصف الثاني', 'الصف الثالث', 'الصف الرابع', 'الصف الخامس'];
  List<String> periods = ['هذا الأسبوع', 'هذا الشهر', 'هذا الفصل', 'هذه السنة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          'التقارير',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    decoration: InputDecoration(
                      labelText: 'الفترة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    items: periods.map((String period) {
                      return DropdownMenuItem<String>(value: period, child: Text(period));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPeriod = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 60.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTab('الحضور', 0),
                _buildTab('السلوك', 1),
                _buildTab('الأداء', 2),
                _buildTab('الواجبات', 3),
              ],
            ),
          ),

          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: _selectedTab == index ? const Color(0xFF7C3AED) : Colors.grey[200],
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: _selectedTab == index ? AppColor.whiteColor(context) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildAttendanceReport();
      case 1:
        return _buildBehaviorReport();
      case 2:
        return _buildPerformanceReport();
      case 3:
        return _buildAssignmentsReport();
      default:
        return _buildAttendanceReport();
    }
  }

  Widget _buildAttendanceReport() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // إحصائيات الحضور
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  'نسبة الحضور',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCircle('85%', 'الحضور', Colors.green),
                    _buildStatCircle('12%', 'التأخير', Colors.orange),
                    _buildStatCircle('3%', 'الغياب', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // قائمة الطلاب
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الحضور',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                ...List.generate(5, (index) => _buildStudentAttendanceItem(index)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBehaviorReport() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  'تقرير السلوك',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCircle('15', 'إيجابي', Colors.green),
                    _buildStatCircle('3', 'سلبي', Colors.red),
                    _buildStatCircle('7', 'محايد', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceReport() {
    return Center(
      child: Text('تقرير الأداء - قيد التطوير', style: TextStyle(fontSize: 16.sp)),
    );
  }

  Widget _buildAssignmentsReport() {
    return Center(
      child: Text('تقرير الواجبات - قيد التطوير', style: TextStyle(fontSize: 16.sp)),
    );
  }

  Widget _buildStatCircle(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.w),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildStudentAttendanceItem(int index) {
    List<Map<String, dynamic>> students = [
      {'name': 'أحمد محمد', 'present': 18, 'absent': 2, 'late': 1},
      {'name': 'فاطمة علي', 'present': 20, 'absent': 0, 'late': 0},
      {'name': 'خالد إبراهيم', 'present': 15, 'absent': 5, 'late': 2},
      {'name': 'سارة عبدالله', 'present': 19, 'absent': 1, 'late': 1},
      {'name': 'محمد حسن', 'present': 17, 'absent': 3, 'late': 2},
    ];

    var student = students[index];
    double percentage = (student['present'] / 20) * 100;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF7C3AED).withOpacity(0.1),
            child: Text('${index + 1}', style: TextStyle(color: const Color(0xFF7C3AED))),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'حضور: ${student['present']} | غياب: ${student['absent']} | تأخير: ${student['late']}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: _getPercentageColor(percentage),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.orange;
    return Colors.red;
  }
}
