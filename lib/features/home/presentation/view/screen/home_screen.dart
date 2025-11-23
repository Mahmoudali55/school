import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/view/widget/hero_next_class_card.dart';
import 'package:my_template/features/home/presentation/view/widget/home_header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/quick_actions_section.dart';
import 'package:my_template/features/home/presentation/view/widget/recent_notifications_section.dart';
import 'package:my_template/features/home/presentation/view/widget/upcoming_tasks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderWidget(studentName: "محمد أحمد", classInfo: "الصف العاشر - علمي"),
              SizedBox(height: 25.h),
              const HeroNextClassCard(),
              SizedBox(height: 25.h),
              const QuickActionsSection(),
              SizedBox(height: 25.h),
              const UpcomingTasksSection(),
              SizedBox(height: 25.h),
              const RecentNotificationsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
