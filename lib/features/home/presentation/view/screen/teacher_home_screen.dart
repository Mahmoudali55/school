import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final teacherData = state.data as TeacherHomeModel;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      teacherName: HiveMethods.getUserName(),
                      subjects: teacherData.subjects,
                    ),
                    SizedBox(height: 25.h),
                    QuickStatsWidget(),
                    SizedBox(height: 25.h),
                    ScheduleWidget(),
                    SizedBox(height: 25.h),
                    QuickActionsWidget(),
                    SizedBox(height: 25.h),
                    RecentMessagesWidget(),
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
