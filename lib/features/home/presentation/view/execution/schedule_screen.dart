import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // اليوم الحالي

  final List<String> _days = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  final Map<String, List<Map<String, dynamic>>> _schedule = {
    'الإثنين': [
      {'subject': 'الرياضيات', 'time': '08:00 - 09:00', 'teacher': 'أ. أحمد', 'room': 'A101'},
      {'subject': 'الفيزياء', 'time': '09:00 - 10:00', 'teacher': 'د. محمد', 'room': 'B202'},
      {'subject': 'الكيمياء', 'time': '10:30 - 11:30', 'teacher': 'أ. فاطمة', 'room': 'C303'},
    ],
    'الثلاثاء': [
      {'subject': 'اللغة العربية', 'time': '08:00 - 09:00', 'teacher': 'أ. خالد', 'room': 'A102'},
      {
        'subject': 'اللغة الإنجليزية',
        'time': '09:00 - 10:00',
        'teacher': 'أ. سارة',
        'room': 'B201',
      },
    ],
    'الأربعاء': [
      {'subject': 'الرياضيات', 'time': '08:00 - 09:00', 'teacher': 'أ. أحمد', 'room': 'A101'},
      {'subject': 'التاريخ', 'time': '09:00 - 10:00', 'teacher': 'أ. علي', 'room': 'D404'},
    ],
    'الخميس': [
      {'subject': 'الفنون', 'time': '08:00 - 09:00', 'teacher': 'أ. لينا', 'room': 'E505'},
      {
        'subject': 'التربية الرياضية',
        'time': '09:00 - 10:00',
        'teacher': 'أ. عمر',
        'room': 'الملعب',
      },
    ],
    'الجمعة': [
      {
        'subject': 'التربية الإسلامية',
        'time': '08:00 - 09:00',
        'teacher': 'أ. إبراهيم',
        'room': 'A103',
      },
    ],
    'السبت': [],
    'الأحد': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        context,
        title: Text(
          AppLocalKay.schedules.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: _viewMonthlySchedule),
        ],
      ),
      body: Column(
        children: [
          // أيام الأسبوع
          SizedBox(
            height: 70.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = index;
                    });
                  },
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: _selectedDay == index ? Colors.blue : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _days[index],
                          style: TextStyle(
                            color: _selectedDay == index
                                ? AppColor.whiteColor(context)
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${_schedule[_days[index]]?.length ?? 0}',
                          style: TextStyle(
                            color: _selectedDay == index
                                ? AppColor.whiteColor(context)
                                : Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          // جدول اليوم
          Expanded(child: _buildDaySchedule(_days[_selectedDay])),
        ],
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    final daySchedule = _schedule[day] ?? [];

    if (daySchedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 60.w, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              AppLocalKay.no_classes_today.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: daySchedule.length,
      itemBuilder: (context, index) {
        return _buildScheduleItem(daySchedule[index], index);
      },
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> classItem, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.school, color: Colors.blue),
        ),
        title: Text(
          classItem['subject'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(classItem['time']),
            SizedBox(height: 2.h),
            Text('${AppLocalKay.teachers.tr()}:${classItem['teacher']}'),
            SizedBox(height: 2.h),
            Text('${AppLocalKay.room.tr()}: ${classItem['room']}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => _setClassReminder(classItem),
        ),
      ),
    );
  }

  void _viewMonthlySchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalKay.monthly_schedule.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _days.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_days[index]),
                subtitle: Text(
                  '${_schedule[_days[index]]?.length ?? 0} ${AppLocalKay.class_count.tr()}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    _selectedDay = index;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _setClassReminder(Map<String, dynamic> classItem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم ضبط منبه لحصة ${classItem['subject']}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
