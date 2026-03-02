import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/stat_card_widget.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final teacherCourses = state.teacherCoursesStatus.data ?? [];
        final totalTodayLessons = teacherCourses.length;
        final teacherClasses = state.teacherClassesStatus.data ?? [];
        final totalAbsentStudents = teacherClasses.fold<int>(
          0,
          (sum, classItem) => sum + (classItem.oldStudent ?? 0),
        );
        return Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: StatCardWidget(
                title: AppLocalKay.daily_schedule.tr(),
                value: "$totalTodayLessons",
                subtitle: AppLocalKay.classes_count.tr(),
                icon: Icons.schedule_rounded,
                color: AppColor.levelColor(context),
              ),
            ),
            Expanded(
              child: StatCardWidget(
                title: AppLocalKay.absences_count.tr(),
                value: "$totalAbsentStudents",
                subtitle: AppLocalKay.absent_student.tr(),
                icon: Icons.person_off_rounded,
                color: AppColor.errorColor(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
