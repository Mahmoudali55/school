// features/class/presentation/execution/class_schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';

class ClassScheduleScreen extends StatefulWidget {
  final SchoolClass schoolClass;

  const ClassScheduleScreen({super.key, required this.schoolClass});

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  int _selectedDay = 0;

  final List<String> _days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];

  final Map<String, List<Map<String, dynamic>>> _scheduleData = {
    'الأحد': [
      {'time': '7:30 - 8:30', 'subject': 'الرياضيات', 'teacher': 'أ. أحمد محمد'},
      {'time': '8:30 - 9:30', 'subject': 'اللغة العربية', 'teacher': 'أ. فاطمة علي'},
      {'time': '9:30 - 10:00', 'subject': 'فسحة', 'teacher': ''},
      {'time': '10:00 - 11:00', 'subject': 'العلوم', 'teacher': 'أ. خالد إبراهيم'},
      {'time': '11:00 - 12:00', 'subject': 'التربية الإسلامية', 'teacher': 'أ. عمر حسن'},
    ],
    'الاثنين': [
      {'time': '7:30 - 8:30', 'subject': 'اللغة الإنجليزية', 'teacher': 'أ. سارة أحمد'},
      {'time': '8:30 - 9:30', 'subject': 'الاجتماعيات', 'teacher': 'أ. محمد عبدالله'},
      {'time': '9:30 - 10:00', 'subject': 'فسحة', 'teacher': ''},
      {'time': '10:00 - 11:00', 'subject': 'التربية الفنية', 'teacher': 'أ. ليلى كمال'},
      {'time': '11:00 - 12:00', 'subject': 'الحاسب الآلي', 'teacher': 'أ. ياسر ناصر'},
    ],
    'الثلاثاء': [
      {'time': '7:30 - 8:30', 'subject': 'الرياضيات', 'teacher': 'أ. أحمد محمد'},
      {'time': '8:30 - 9:30', 'subject': 'التربية البدنية', 'teacher': 'أ. وليد صالح'},
      {'time': '9:30 - 10:00', 'subject': 'فسحة', 'teacher': ''},
      {'time': '10:00 - 11:00', 'subject': 'العلوم', 'teacher': 'أ. خالد إبراهيم'},
      {'time': '11:00 - 12:00', 'subject': 'اللغة العربية', 'teacher': 'أ. فاطمة علي'},
    ],
    'الأربعاء': [
      {'time': '7:30 - 8:30', 'subject': 'اللغة الإنجليزية', 'teacher': 'أ. سارة أحمد'},
      {'time': '8:30 - 9:30', 'subject': 'التربية الإسلامية', 'teacher': 'أ. عمر حسن'},
      {'time': '9:30 - 10:00', 'subject': 'فسحة', 'teacher': ''},
      {'time': '10:00 - 11:00', 'subject': 'الاجتماعيات', 'teacher': 'أ. محمد عبدالله'},
      {'time': '11:00 - 12:00', 'subject': 'النشاط الطلابي', 'teacher': 'أ. وليد صالح'},
    ],
    'الخميس': [
      {'time': '7:30 - 8:30', 'subject': 'الرياضيات', 'teacher': 'أ. أحمد محمد'},
      {'time': '8:30 - 9:30', 'subject': 'الحاسب الآلي', 'teacher': 'أ. ياسر ناصر'},
      {'time': '9:30 - 10:00', 'subject': 'فسحة', 'teacher': ''},
      {'time': '10:00 - 11:00', 'subject': 'التربية الفنية', 'teacher': 'أ. ليلى كمال'},
      {'time': '11:00 - 12:00', 'subject': 'اللغة العربية', 'teacher': 'أ. فاطمة علي'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جدول حصص ${widget.schoolClass.name}',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor:  AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // أيام الأسبوع
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: ChoiceChip(
                    label: Text(_days[index]),
                    selected: _selectedDay == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDay = index;
                      });
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: _selectedDay == index ?  AppColor.whiteColor(context) : Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              },
            ),
          ),

          // جدول الحصص
          Expanded(
            child: ListView.builder(
              itemCount: _scheduleData[_days[_selectedDay]]!.length,
              itemBuilder: (context, index) {
                final period = _scheduleData[_days[_selectedDay]]![index];
                return _buildPeriodCard(period, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(Map<String, dynamic> period, int index) {
    final isBreak = period['subject'] == 'فسحة';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

      color: isBreak ? Colors.orange.shade50 :  AppColor.whiteColor(context),
      child: Container(
        child: ListTile(
          leading: Container(
            width: 50.w,

            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isBreak ? Colors.orange.shade100 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBreak ? Icons.coffee : Icons.school,
                  size: 20.w,
                  color: isBreak ? Colors.orange : Colors.blue,
                ),
              ],
            ),
          ),
          title: Text(
            period['subject'],
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isBreak ? Colors.orange : Colors.grey.shade800,
            ),
          ),
          subtitle: period['teacher'].isNotEmpty
              ? Text(
                  period['teacher'],
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                )
              : null,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                period['time'],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              if (!isBreak)
                Text(
                  '60 دقيقة',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
