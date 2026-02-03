import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/stat_card_widget.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Calculate statistics from teacher classes data
        final teacherClasses = state.teacherClassesStatus.data ?? [];
        final teacherCourses = state.teacherCoursesStatus.data ?? [];

        // Total number of classes
        final totalClasses = teacherClasses.length;

        // Total number of students across all classes
        final totalStudents = teacherClasses.fold<int>(
          0,
          (sum, classItem) => sum + (classItem.newStudent ?? 0) + (classItem.oldStudent ?? 0),
        );

        // Number of courses taught
        final totalCourses = teacherCourses.length;

        return Row(
          children: [
            Expanded(
              child: StatCardWidget(
                title: "إجمالي الفصول",
                value: "$totalClasses",
                subtitle: "الفصول المُدرَّسة",
                icon: Icons.class_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCardWidget(
                title: "إجمالي الطلاب",
                value: "$totalStudents",
                subtitle: "طالب في جميع الفصول",
                icon: Icons.people_rounded,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        );
      },
    );
  }
}
