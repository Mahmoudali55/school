import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/class_month_result_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TeacherGradesExamsScreen extends StatefulWidget {
  const TeacherGradesExamsScreen({super.key});

  @override
  State<TeacherGradesExamsScreen> createState() => _TeacherGradesExamsScreenState();
}

class _TeacherGradesExamsScreenState extends State<TeacherGradesExamsScreen> {
  TeacherLevelModel? _selectedLevel;
  TeacherClassModels? _selectedClass;
  int? _selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
        context.read<HomeCubit>().teacherLevel(stageCode);
      }
    });
  }

  void _onLevelChanged(TeacherLevelModel? level) {
    setState(() {
      _selectedLevel = level;
      _selectedClass = null;
    });

    if (level != null) {
      final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
      final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
      context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, level.levelCode);
    }
  }

  void _onClassChanged(TeacherClassModels? newValue) {
    setState(() {
      _selectedClass = newValue;
    });
    _fetchResults();
  }

  void _onMonthChanged(int? month) {
    setState(() {
      _selectedMonth = month;
    });
    _fetchResults();
  }

  void _fetchResults() {
    if (_selectedClass != null && _selectedMonth != null) {
      context.read<HomeCubit>().classMonthResult(
        classCode: _selectedClass!.classCode,
        month: _selectedMonth!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.grades_exams_teacher.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(child: _buildSelectionCard(state)),
                Gap(24.h),
                if (state.classMonthResultStatus.isLoading)
                  const Center(child: CustomLoading())
                else if (state.classMonthResultStatus.isFailure)
                  Center(child: Text(state.classMonthResultStatus.error ?? ""))
                else if (state.classMonthResultStatus.isSuccess) ...[
                  if (state.classMonthResultStatus.data!.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.info_outline, size: 50.sp, color: AppColor.greyColor(context)),
                          Gap(10.h),
                          Text(
                            AppLocalKay.no_results.tr(),
                            style: AppTextStyle.bodyLarge(
                              context,
                            ).copyWith(color: AppColor.greyColor(context)),
                          ),
                        ],
                      ),
                    )
                  else ...[ 
                    _buildSectionHeader(AppLocalKay.grades_exams_teacher.tr()),
                    Gap(16.h),
                    ...state.classMonthResultStatus.data!.map((result) {
                      final percentage = result.courseDegree != null && result.courseDegree! > 0
                          ? (result.studentDegree ?? 0) / result.courseDegree!
                          : 0.0;
                      return _buildClassPerformanceCard(
                        result.courseName ?? result.className ?? "",
                        "${(percentage * 100).toStringAsFixed(0)}%",
                        percentage,
                        _getRandomColor(result.courseCode ?? 0),
                      );
                    }).toList(),
                  ],
                ] else
                  Center(
                    child: Text(
                      AppLocalKay.selectClassToGenerate.tr(),
                      style: AppTextStyle.bodyLarge(
                        context,
                      ).copyWith(color: AppColor.greyColor(context)),
                    ),
                  ),
                Gap(20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRandomColor(int seed) {
    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF6366F1),
    ];
    return colors[seed % colors.length];
  }

  Widget _buildSelectionCard(HomeState state) {
    final levels = state.teacherLevelStatus.data ?? [];
    final classes = state.teacherClassesStatus.data ?? [];
    final months = List.generate(12, (index) => index + 1);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.05)),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.class_details.tr(),
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(16.h),
          CustomDropdownFormField(
            value: _selectedLevel,
            errorText: '',
            submitted: false,
            hint: AppLocalKay.select_level.tr(),
            items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l.levelName))).toList(),
            onChanged: state.teacherLevelStatus.isLoading ? null : _onLevelChanged,
          ),
          Gap(12.h),
          CustomDropdownFormField(
            value: _selectedClass,
            errorText: '',
            submitted: false,
            hint: AppLocalKay.select_class.tr(),
            items: classes
                .map((c) => DropdownMenuItem(value: c, child: Text(c.classNameAr)))
                .toList(),
            onChanged: _selectedLevel == null || state.teacherClassesStatus.isLoading
                ? null
                : _onClassChanged,
          ),
          Gap(12.h),
          CustomDropdownFormField<int>(
            value: _selectedMonth,
            errorText: '',
            submitted: false,
            hint: AppLocalKay.select_month.tr(),
            items: months.map((m) => DropdownMenuItem(value: m, child: Text("شهر $m"))).toList(),
            onChanged: _onMonthChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(List<ClassMonthResultModel> results) {
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.05)),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.subject_analysis.tr(),
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(20.h),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: results.isEmpty
                    ? 100
                    : results.map((e) => e.courseDegree ?? 100).reduce(math.max),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= results.length) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            results[index].courseName?.substring(
                                  0,
                                  math.min(5, results[index].courseName?.length ?? 0),
                                ) ??
                                "",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: results.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.studentDegree ?? 0,
                        color: AppColor.primaryColor(context),
                        width: 16.w,
                        borderRadius: BorderRadius.circular(4.r),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: entry.value.courseDegree ?? 100,
                          color: AppColor.primaryColor(context).withOpacity(0.1),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return FadeInRight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildClassPerformanceCard(
    String className,
    String percentage,
    double progress,
    Color color,
  ) {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor(context).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.school_rounded, color: color, size: 20.w),
                    ),
                    Gap(12.w),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        className,
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  percentage,
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Gap(16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 8.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
