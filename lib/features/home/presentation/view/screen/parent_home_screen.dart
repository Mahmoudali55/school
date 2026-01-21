import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/live_tracking_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/requests_section_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/student_snapshot_section_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/urgent_alerts_widget%20.dart';
import 'package:my_template/features/home/presentation/view/widget/student/gamification_banner.dart';

class HomeParentScreen extends StatelessWidget {
  const HomeParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final parentData = state.data as ParentHomeModel;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      parentName: parentData.userName,
                      students: parentData.students,
                      selectedStudent: parentData.selectedStudent,
                    ),
                    SizedBox(height: 25.h),
                    GamificationBanner(
                      points: parentData.points,
                      level: parentData.level,
                      badges: parentData.badges,
                    ),
                    SizedBox(height: 25.h),
                    const StudentSnapshotWidget(),
                    SizedBox(height: 25.h),
                    const LiveTrackingWidget(),
                    SizedBox(height: 25.h),
                    RequestsSectionWidget(
                      selectedStudent: parentData.selectedStudent,
                      students: parentData.students,
                    ),
                    SizedBox(height: 25.h),
                    const UrgentAlertsWidget(),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
