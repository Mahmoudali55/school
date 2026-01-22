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

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _studentCode = widget.studentCode;
    _loadAbsentCount();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _pageController.hasClients) {
        int nextPage = (_pageController.page?.round() ?? 0) + 1;
        if (nextPage >= 5) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  late int _studentCode;

  void _loadAbsentCount() {
    context.read<HomeCubit>().studentAbsentCount(_studentCode);
  }

  @override
  void didUpdateWidget(covariant StudentSnapshotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentCode != widget.studentCode) {
      _studentCode = widget.studentCode;
      _loadAbsentCount();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Grades Slider Header ---
        Text(
          AppLocalKay.grades.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 12.h),

        // --- Grades Slider Component ---
        Container(
          height: 140.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.primaryColor(context), const Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor(context).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColor.whiteColor(context).withOpacity(0.1),
                ),
              ),
              PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildGradeItem(
                    context,
                    "الرياضيات",
                    "95/100",
                    "تفوق ملحوظ",
                    Icons.calculate_outlined,
                  ),
                  _buildGradeItem(
                    context,
                    "العلوم",
                    "88/100",
                    "أداء جيد جدًا",
                    Icons.science_outlined,
                  ),
                  _buildGradeItem(context, "اللغة العربية", "92/100", "ممتاز", Icons.translate),
                  _buildGradeItem(context, "English Language", "90/100", "Very Good", Icons.abc),
                  _buildGradeItem(context, "التاريخ", "85/100", "جيد جداً", Icons.history_edu),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // --- Absence Section Header ---
        Text(
          AppLocalKay.quick_stats.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 12.h),

        // --- Absence Component ---
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
                        Text("أيام الغياب", style: AppTextStyle.bodyMedium(context)),
                        Text(
                          "$count أيام هذا الشهر",
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
      builder: (context) => Container(
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
            Expanded(
              child: ListView(
                children: [
                  _buildAbsenceTile(context, "الإثنين، 10 يناير 2026", "إجازة مرضية", Colors.blue),
                  _buildAbsenceTile(
                    context,
                    "الأربعاء، 15 ديسمبر 2025",
                    "ظروف عائلية",
                    Colors.orange,
                  ),
                  _buildAbsenceTile(context, "الأحد، 20 نوفمبر 2025", "غياب بدون عذر", Colors.red),
                ],
              ),
            ),
          ],
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
