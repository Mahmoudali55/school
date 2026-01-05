import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
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
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final studentData = state.data as StudentHomeModel;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeaderWidget(
                      studentName: studentData.userName,
                      classInfo: studentData.classInfo,
                    ),
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
