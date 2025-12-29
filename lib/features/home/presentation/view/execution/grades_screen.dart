import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:share_plus/share_plus.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int _selectedTerm = 0;
  final List<String> _terms = ['الفصل الأول', 'الفصل الثاني', 'الفصل الثالث'];

  final Map<String, List<Map<String, dynamic>>> _grades = {
    'الفصل الأول': [
      {'subject': 'الرياضيات', 'grade': '95', 'maxGrade': '100', 'percentage': 95.0},
      {'subject': 'الفيزياء', 'grade': '88', 'maxGrade': '100', 'percentage': 88.0},
      {'subject': 'الكيمياء', 'grade': '92', 'maxGrade': '100', 'percentage': 92.0},
      {'subject': 'اللغة العربية', 'grade': '85', 'maxGrade': '100', 'percentage': 85.0},
      {'subject': 'اللغة الإنجليزية', 'grade': '90', 'maxGrade': '100', 'percentage': 90.0},
    ],
    'الفصل الثاني': [
      {'subject': 'الرياضيات', 'grade': '92', 'maxGrade': '100', 'percentage': 92.0},
      {'subject': 'الفيزياء', 'grade': '86', 'maxGrade': '100', 'percentage': 86.0},
    ],
    'الفصل الثالث': [],
  };

  @override
  Widget build(BuildContext context) {
    final currentTermGrades = _grades[_terms[_selectedTerm]] ?? [];
    final average = _calculateAverage(currentTermGrades);

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        context,
        title: Text(
          AppLocalKay.grades.tr(),
          style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: _shareGrades)],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_terms.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTerm = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _selectedTerm == index ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _terms[index],
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: _selectedTerm == index ? AppColor.whiteColor(context) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          if (currentTermGrades.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _getAverageColor(average),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalKay.gpa.tr(),
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.whiteColor(context), fontSize: 14.sp),
                      ),
                      Text(
                        average.toStringAsFixed(1),
                        style: AppTextStyle.headlineLarge(context).copyWith(
                          color: AppColor.whiteColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalKay.assessment.tr(),
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.whiteColor(context), fontSize: 14.sp),
                      ),
                      Text(
                        _getGradeDescription(average),
                        style: AppTextStyle.titleLarge(context).copyWith(
                          color: AppColor.whiteColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],

          Expanded(
            child: currentTermGrades.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grade, size: 60.w, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalKay.no_grades.tr(),
                          style: AppTextStyle.titleMedium(context).copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: currentTermGrades.length,
                    itemBuilder: (context, index) {
                      return _buildGradeItem(currentTermGrades[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(Map<String, dynamic> grade) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: _getGradeColor(grade['percentage']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.school, color: _getGradeColor(grade['percentage'])),
        ),
        title: Text(
          grade['subject'],
          style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('${AppLocalKay.grade.tr()}: ${grade['grade']}/${grade['maxGrade']}'),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: grade['percentage'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getGradeColor(grade['percentage'])),
            ),
          ],
        ),
        trailing: Text(
          '${grade['percentage']}%',
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: _getGradeColor(grade['percentage'])),
        ),
        onTap: () => _viewGradeDetails(grade),
      ),
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  Color _getAverageColor(double average) {
    if (average >= 90) return Colors.green;
    if (average >= 80) return Colors.blue;
    if (average >= 70) return Colors.orange;
    return Colors.red;
  }

  String _getGradeDescription(double average) {
    if (average >= 95) return 'امتياز';
    if (average >= 90) return 'ممتاز';
    if (average >= 85) return 'جيد جداً';
    if (average >= 80) return 'جيد';
    return 'مقبول';
  }

  double _calculateAverage(List<Map<String, dynamic>> grades) {
    if (grades.isEmpty) return 0.0;
    double total = 0.0;
    for (var grade in grades) {
      total += grade['percentage'];
    }
    return total / grades.length;
  }

  void _shareGrades() {
    final gradesText = "درجات الطالب:\nرياضيات: 95\nعلوم: 90\nلغة عربية: 92";

    SharePlus.instance.share(ShareParams(text: gradesText));
  }

  void _viewGradeDetails(Map<String, dynamic> grade) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل درجة ${grade['subject']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المادة: ${grade['subject']}'),
            Text('الدرجة: ${grade['grade']}/${grade['maxGrade']}'),
            Text('النسبة: ${grade['percentage']}%'),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: grade['percentage'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getGradeColor(grade['percentage'])),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
      ),
    );
  }
}
