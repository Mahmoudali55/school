import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/view/execution/attendance_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/behavior_report_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/create_assignment_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/reports_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/send_notification_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/upload_lesson_screen.dart';

class ActionCardWidget extends StatelessWidget {
  final QuickAction action;
  const ActionCardWidget({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToScreen(context, action.title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: action.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, color: action.color, size: 32.w),
            SizedBox(height: 8.h),
            Text(
              action.title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String title) {
    Widget screen;

    switch (title) {
      case "رفع درس جديد":
        screen = const UploadLessonScreen();
        break;
      case "تسجيل الحضور":
        screen = const AttendanceScreen();
        break;
      case "إنشاء واجب":
        screen = const CreateAssignmentScreen();
        break;
      case "إرسال إشعار":
        screen = const SendNotificationScreen();
        break;
      case "تقرير سلوك":
        screen = const BehaviorReportScreen();
        break;
      case "التقارير":
        screen = const ReportsScreen();
        break;
      default:
        screen = const UploadLessonScreen();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
