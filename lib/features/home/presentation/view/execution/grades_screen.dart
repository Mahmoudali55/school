import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/student_course_degree_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:share_plus/share_plus.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> with TickerProviderStateMixin {
  int _selectedMonthIndex = 0;
  final List<Map<String, dynamic>> _months = [
    {'name': 'سبتمبر', 'id': 9},
    {'name': 'أكتوبر', 'id': 10},
    {'name': 'نوفمبر', 'id': 11},
    {'name': 'ديسمبر', 'id': 12},
    {'name': 'يناير', 'id': 1},
    {'name': 'فبراير', 'id': 2},
    {'name': 'مارس', 'id': 3},
    {'name': 'أبريل', 'id': 4},
    {'name': 'مايو', 'id': 5},
    {'name': 'يونيو', 'id': 6},
  ];

  late AnimationController _headerController;
  late Animation<double> _headerScale;
  late ScrollController _monthScrollController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _headerScale = CurvedAnimation(parent: _headerController, curve: Curves.elasticOut);
    _headerController.forward();
    _monthScrollController = ScrollController();

    _setInitialMonth();
    _fetchData();
  }

  void _setInitialMonth() {
    final currentMonth = DateTime.now().month;
    final index = _months.indexWhere((m) => m['id'] == currentMonth);
    if (index != -1) {
      _selectedMonthIndex = index;
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _monthScrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final cubit = context.read<HomeCubit>();
    int? code;

    final type = HiveMethods.getType().trim();
    if (type == '1' || type == 'student') {
      code = int.tryParse(HiveMethods.getUserCode());
    } else {
      code = cubit.state.selectedStudent?.studentCode;
    }

    if (code != null) {
      cubit.studentCourseDegree(code, _months[_selectedMonthIndex]['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        context,
        title: Text(
          AppLocalKay.grades.tr(),
          style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final grades = state.studentCourseDegreeStatus.data ?? [];
              return IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: grades.isNotEmpty ? () => _shareGrades(grades) : null,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final grades = state.studentCourseDegreeStatus.data ?? [];
          final isLoading = state.studentCourseDegreeStatus.isLoading;
          final error = state.studentCourseDegreeStatus.error;
          final average = _calculateAverage(grades);

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(child: _buildMonthSelector()),
                if (isLoading)
                  const SliverFillRemaining(child: Center(child: CustomLoading()))
                else if (error != null)
                  SliverFillRemaining(child: Center(child: Text(error)))
                else if (grades.isEmpty)
                  _buildEmptyState()
                else ...[
                  SliverToBoxAdapter(
                    child: ScaleTransition(scale: _headerScale, child: _buildGPACard(average)),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final grade = grades[index];
                        final percentage = (grade.studentDegree / grade.courseDegree) * 100;
                        final color = _getStatusColor(percentage);
                        return _buildGradeCard(grade, color);
                      }, childCount: grades.length),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: ListView.builder(
        controller: _monthScrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _months.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedMonthIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedMonthIndex = index);
              _fetchData();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(left: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColor.primaryColor(context),
                          AppColor.primaryColor(context).withValues(alpha: 0.8),
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColor.whiteColor(context),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColor.primaryColor(context).withValues(alpha: (0.3))
                        : AppColor.blackColor(context).withValues(alpha: (0.05)),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _months[index]['name'],
                style: AppTextStyle.bodySmall(context).copyWith(
                  color: isSelected ? AppColor.whiteColor(context) : AppColor.greyColor(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGPACard(double average) {
    final color = _getStatusColor(average);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: (0.8)),
            color.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColor.whiteColor(context).withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            left: 20,
            bottom: -30,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColor.whiteColor(context).withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalKay.gpa.tr(),
                        style: AppTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: AppColor.whiteColor(context).withValues(alpha: 0.9)),
                      ),
                      Gap(4.h),
                      Text(
                        '${average.toStringAsFixed(1)}%',
                        style: AppTextStyle.headlineLarge(context).copyWith(
                          color: AppColor.whiteColor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 42.sp,
                        ),
                      ),
                      Gap(8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor(context).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _getGradeDescription(average),
                          style: AppTextStyle.bodySmall(context).copyWith(
                            color: AppColor.whiteColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: average / 100,
                        strokeWidth: 10,
                        backgroundColor: AppColor.whiteColor(context).withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.whiteColor(context)),
                      ),
                      Icon(
                        Icons.emoji_events_rounded,
                        color: AppColor.whiteColor(context),
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCard(StudentCourseDegree grade, Color color) {
    final percentage = (grade.studentDegree / grade.courseDegree) * 100;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewGradeDetails(grade, color),
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: (0.1)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.auto_stories_rounded, color: color),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grade.courseName,
                            style: AppTextStyle.bodyLarge(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${AppLocalKay.grade.tr()}: ${grade.studentDegree}/${grade.courseDegree}',
                            style: AppTextStyle.bodySmall(
                              context,
                            ).copyWith(color: AppColor.grey600Color(context)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: AppTextStyle.titleMedium(
                            context,
                          ).copyWith(color: color, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _getGradeDescription(percentage),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: color.withValues(alpha: 0.7), fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(16.h),
                Stack(
                  children: [
                    Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppColor.grey100Color(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: 8.h,
                      width: (MediaQuery.of(context).size.width - 64.w) * (percentage / 100),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color]),
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Icon(
                Icons.analytics_outlined,
                size: 80.w,
                color: AppColor.primaryColor(context),
              ),
            ),
            Gap(16.h),
            Text(
              AppLocalKay.no_grades.tr(),
              style: AppTextStyle.bodyLarge(
                context,
              ).copyWith(color: AppColor.grey600Color(context)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 90) return AppColor.secondAppColor(context);
    if (percentage >= 80) return AppColor.primaryColor(context);
    if (percentage >= 70) return AppColor.accentColor(context);
    return AppColor.errorColor(context);
  }

  String _getGradeDescription(double percentage) {
    if (percentage >= 95) return AppLocalKay.excellentHigh.tr();
    if (percentage >= 90) return AppLocalKay.excellent.tr();
    if (percentage >= 85) return AppLocalKay.veryGoodHigh.tr();
    if (percentage >= 80) return AppLocalKay.veryGood.tr();
    if (percentage >= 75) return AppLocalKay.goodHigh.tr();
    if (percentage >= 70) return AppLocalKay.good.tr();
    if (percentage >= 60) return AppLocalKay.pass.tr();
    return AppLocalKay.fail.tr();
  }

  double _calculateAverage(List<StudentCourseDegree> grades) {
    if (grades.isEmpty) return 0.0;
    double totalPercent = 0.0;
    for (var grade in grades) {
      totalPercent += (grade.studentDegree / grade.courseDegree) * 100;
    }
    return totalPercent / grades.length;
  }

  void _shareGrades(List<StudentCourseDegree> grades) {
    String gradesText =
        "📊 *${AppLocalKay.grades_report_title.tr()}- ${_months[_selectedMonthIndex]['name']}*\n\n";
    for (var grade in grades) {
      final p = (grade.studentDegree / grade.courseDegree) * 100;
      gradesText +=
          "🔹 ${grade.courseName}: ${grade.studentDegree}/${grade.courseDegree} (${p.toStringAsFixed(0)}%)\n";
    }
    final avg = _calculateAverage(grades);
    gradesText += "\n🏆 *${AppLocalKay.cumulative_rate.tr()} ${avg.toStringAsFixed(1)}%*";

    SharePlus.instance.share(
      ShareParams(text: gradesText, subject: AppLocalKay.grades_report.tr()),
    );
  }

  void _viewGradeDetails(StudentCourseDegree grade, Color color) {
    final percentage = (grade.studentDegree / grade.courseDegree) * 100;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.grey300Color(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Gap(24.h),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, color: color, size: 30),
                Gap(12.w),
                Text(
                  '${AppLocalKay.grades.tr()}: ${grade.courseName}',
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Gap(20.h),
            _buildDetailRow(
              AppLocalKay.grade.tr(),
              '${grade.studentDegree} / ${grade.courseDegree}',
            ),
            _buildDetailRow(AppLocalKay.percentage.tr(), '${percentage.toStringAsFixed(1)}%'),
            _buildDetailRow(AppLocalKay.rate.tr(), _getGradeDescription(percentage)),
            if (grade.notes != null && grade.notes!.isNotEmpty)
              _buildDetailRow(AppLocalKay.note.tr(), grade.notes!),
            Gap(24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                ),
                child: Text(
                  AppLocalKay.cancel.tr(),
                  style: AppTextStyle.bodyLarge(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.grey600Color(context)),
          ),
          Text(value, style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
