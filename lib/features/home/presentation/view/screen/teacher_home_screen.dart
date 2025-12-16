import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/header_widget_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/quick_actions_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/quick_stats_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/recent_messages_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/schedule_widget.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    String teacherName = "أ. أحمد محمد";
    List<String> subjects = ["الفيزياء - الصف 10أ", "الفيزياء - الصف 10ب", "الرياضيات - الصف 9أ"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(teacherName: teacherName, subjects: subjects),
              SizedBox(height: 25.h),
              QuickStatsWidget(),
              SizedBox(height: 25.h),
              ScheduleWidget(),
              SizedBox(height: 25.h),
              QuickActionsWidget(),
              SizedBox(height: 25.h),

              SizedBox(height: 25.h),
              RecentMessagesWidget(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
