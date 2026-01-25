import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class StudentSnapshotWidget extends StatefulWidget {
  final int studentCode;
  const StudentSnapshotWidget({super.key, required this.studentCode});

  @override
  State<StudentSnapshotWidget> createState() => _StudentSnapshotWidgetState();
}

class _StudentSnapshotWidgetState extends State<StudentSnapshotWidget> {
  final PageController _pageController = PageController();
  late Timer _timer;
  late int _studentCode;

  @override
  void initState() {
    super.initState();
    _studentCode = widget.studentCode;
    _loadData();
    _startAutoScroll();
  }

  void _loadData() {
    final cubit = context.read<HomeCubit>();
    cubit.studentAbsentCount(_studentCode);
    cubit.studentCourseDegree(_studentCode, 1);
    cubit.studentAbsentDataDetails(_studentCode);
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
      _loadData();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // --- حساب الحالة بناءً على النسبة ---
  String _gradeStatus(double studentDegree, double courseDegree) {
    final percentage = (studentDegree / courseDegree) * 100;
    if (percentage >= 90) return "ممتاز";
    if (percentage >= 75) return "جيد جدًا";
    if (percentage >= 60) return "جيد";
    return "ضعيف";
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
        SizedBox(height: 12.h),

        // --- Grades Slider Dynamic ---
        // --- Grades Slider Dynamic ---
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final grades = state.studentCourseDegreeStatus.data ?? [];

            if (state.studentCourseDegreeStatus.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (grades.isEmpty) {
              return Center(child: Text("لا توجد درجات", style: AppTextStyle.bodyMedium(context)));
            }

            return SizedBox(
              height: 140.h,
              child: PageView.builder(
                controller: _pageController,
                physics: grades.length <= 1
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final item = grades[index];

                  // --- نسبة الطالب + الحالة ---
                  final percentage = (item.studentDegree / item.courseDegree) * 100;
                  String status;
                  if (percentage >= 90) {
                    status = "ممتاز";
                  } else if (percentage >= 75) {
                    status = "جيد جدًا";
                  } else if (percentage >= 60) {
                    status = "جيد";
                  } else {
                    status = "ضعيف";
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.primaryColor(context), const Color(0xFF1E40AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor(context).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.courseName,
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColor.whiteColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${item.studentDegree}",
                              style: AppTextStyle.headlineLarge(context).copyWith(
                                color: AppColor.whiteColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 28.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h, left: 4.w),
                              child: Text(
                                "/${item.courseDegree}",
                                style: AppTextStyle.bodyLarge(
                                  context,
                                ).copyWith(color: AppColor.whiteColor(context)),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor(context).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                status,
                                style: AppTextStyle.bodySmall(context).copyWith(
                                  color: AppColor.whiteColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        LinearProgressIndicator(
                          value: item.studentDegree / item.courseDegree,
                          backgroundColor: AppColor.whiteColor(context).withOpacity(0.3),
                          color: Colors.yellowAccent,
                          minHeight: 6.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),

        SizedBox(height: 24.h),

        // --- Absence Section ---
        Text(
          AppLocalKay.quick_stats.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 12.h),

        // --- Absences ---
        GestureDetector(
          onTap: () => _showAbsenceDetails(context),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final count = state.studentAbsentCountStatus.data?.firstOrNull?.absentCount ?? 0;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor(context).withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_busy_outlined, size: 28, color: Colors.red),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalKay.absences.tr(), style: AppTextStyle.bodyMedium(context)),
                        Text(
                          "$count ${AppLocalKay.day.tr()}",
                          style: AppTextStyle.titleLarge(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGradeItem(
    BuildContext context,
    String subject,
    String grade,
    String status,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.whiteColor(context).withOpacity(0.8), size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                subject,
                style: AppTextStyle.bodyMedium(context).copyWith(
                  color: AppColor.whiteColor(context).withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                grade.split('/')[0],
                style: AppTextStyle.headlineLarge(context).copyWith(
                  color: AppColor.whiteColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
                child: Text(
                  " / ${grade.split('/')[1]}",
                  style: AppTextStyle.bodyLarge(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAbsenceDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final absenceDetails = state.studentAbsentDataStatus.data ?? [];

            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "سجل الغياب",
                    style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  if (state.studentAbsentDataStatus.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (absenceDetails.isEmpty)
                    const Expanded(child: Center(child: Text("لا يوجد سجل غياب")))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: absenceDetails.length,
                        itemBuilder: (context, index) {
                          final item = absenceDetails[index];
                          // توضيح: يمكن تخصيص الألوان بناءً على نوع الغياب إذا توفرت المعلومات
                          return _buildAbsenceTile(
                            context,
                            item.absentDate,
                            item.notes ?? "بدون عذر",
                            item.absentType == 1 ? Colors.red : Colors.orange,
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAbsenceTile(BuildContext context, String date, String reason, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.grey50Color(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                reason,
                style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
