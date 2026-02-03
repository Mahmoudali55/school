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
  void initState() {
    super.initState();
    // Fetch teacher classes and courses for statistics
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final userCode = int.tryParse(HiveMethods.getUserCode()) ?? 0;
        final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
        final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
        final levelCode = int.tryParse(HiveMethods.getUserLevelCode().toString()) ?? 0;

        context.read<HomeCubit>().teacherCourses(userCode);
        context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, levelCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final data = state.data;
            final teacherData = data is TeacherHomeModel ? data : null;

            if (state.isLoading && data == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (teacherData != null) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(teacherName: HiveMethods.getUserName()),
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
            } else if (state.errorMessage != null && data == null) {
              return Center(child: Text(state.errorMessage!));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
