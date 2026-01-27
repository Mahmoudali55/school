import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/show_absence_details_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/student_absence_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/student_grades_widget.dart';

class StudentSnapshotWidget extends StatefulWidget {
  final int? studentCode;
  const StudentSnapshotWidget({super.key, this.studentCode});

  @override
  State<StudentSnapshotWidget> createState() => _StudentSnapshotWidgetState();
}

class _StudentSnapshotWidgetState extends State<StudentSnapshotWidget> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int? _studentCode;

  @override
  void initState() {
    super.initState();
    _studentCode = widget.studentCode;
    if (_studentCode != null) {
      _loadData();
    }
    _startAutoScroll();
  }

  void _loadData() {
    if (_studentCode == null) return;
    final cubit = context.read<HomeCubit>();
    cubit.studentAbsentCount(_studentCode!);
    cubit.studentCourseDegree(_studentCode!, 1);
    cubit.studentAbsentDataDetails(_studentCode!);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _pageController.hasClients) {
        final grades = context.read<HomeCubit>().state.studentCourseDegreeStatus.data ?? [];
        if (grades.length <= 1) return;

        int nextPage = (_pageController.page?.round() ?? 0) + 1;
        if (nextPage >= grades.length) nextPage = 0;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant StudentSnapshotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentCode != widget.studentCode) {
      _studentCode = widget.studentCode;
      if (_studentCode != null) {
        _loadData();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Grades Header ---
        Text(
          AppLocalKay.grades.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        Gap(12.h),

        // --- Grades Slider Dynamic ---
        // --- Grades Slider Dynamic ---
        StudentGradesWidget(studentCode: _studentCode, pageController: _pageController),

        Gap(24.h),

        // --- Absence Section ---
        Text(
          AppLocalKay.quick_stats.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        Gap(12.h),

        // --- Absences ---
        GestureDetector(
          onTap: () => showAbsenceDetails(context),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final count = (_studentCode != null)
                  ? state.studentAbsentCountStatus.data?.firstOrNull?.absentCount ?? 0
                  : 0;

              return StudentAbsenceWidget(count: count);
            },
          ),
        ),
      ],
    );
  }
}
