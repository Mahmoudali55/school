import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/financial_status_widget%20.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/live_tracking_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/student_snapshot_section_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/urgent_alerts_widget%20.dart';

class HomeParentScreen extends StatelessWidget {
  const HomeParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String parentName = "أحمد محمد";
    List<String> students = ["أحمد", "ليلى"];
    String selectedStudent = students[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                parentName: parentName,
                students: students,
                selectedStudent: selectedStudent,
              ),
              SizedBox(height: 25.h),
              const StudentSnapshotWidget(),
              SizedBox(height: 25.h),
              const LiveTrackingWidget(),
              SizedBox(height: 25.h),
              const FinancialStatusWidget(),
              SizedBox(height: 25.h),
              const UrgentAlertsWidget(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
