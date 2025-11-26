import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/schedule_Item_widget.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<ScheduleItem> scheduleItems = [
      ScheduleItem(
        time: "٨:٠٠ - ٨:٤٥",
        subject: "الفيزياء",
        classroom: "الصف 10أ",
        room: "المعمل ١",
        isCurrent: true,
      ),
      ScheduleItem(
        time: "٨:٤٥ - ٩:٣٠",
        subject: "الفيزياء",
        classroom: "الصف 10ب",
        room: "القاعة ٢٠١",
        isCurrent: false,
      ),
      ScheduleItem(
        time: "١٠:٠٠ - ١٠:٤٥",
        subject: "الرياضيات",
        classroom: "الصف 9أ",
        room: "القاعة ١٠٥",
        isCurrent: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "جدول الحصص اليومي",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              "اليوم - ${_getTodayDate()}",
              style: TextStyle(color: const Color(0xFF6B7280), fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(children: scheduleItems.map((item) => ScheduleItemWidget(item: item)).toList()),
      ],
    );
  }

  String _getTodayDate() {
    DateTime now = DateTime.now();
    List<String> days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return '${now.day}/${now.month}/${now.year} - ${days[now.weekday - 1]}';
  }
}
