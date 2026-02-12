import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TeacherGradesExamsScreen extends StatefulWidget {
  const TeacherGradesExamsScreen({super.key});

  @override
  State<TeacherGradesExamsScreen> createState() =>
      _TeacherGradesExamsScreenState();
}

class _TeacherGradesExamsScreenState extends State<TeacherGradesExamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.grades_exams_teacher.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.blackColor(context),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            FadeInDown(child: _buildPerformanceChart()),
            Gap(24.h),
            _buildSectionHeader("تحليل الدرجات حسب الصف"),
            Gap(16.h),
            _buildClassPerformanceCard(
              "الصف الأول - أ",
              "88%",
              0.88,
              const Color(0xFF8B5CF6),
            ),
            _buildClassPerformanceCard(
              "الصف الثاني - ب",
              "75%",
              0.75,
              const Color(0xFFEC4899),
            ),
            _buildClassPerformanceCard(
              "الصف الثالث - ج",
              "92%",
              0.92,
              const Color(0xFF10B981),
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "معدل النجاح الشهري",
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(20.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 4),
                      FlSpot(2, 3.5),
                      FlSpot(3, 5),
                      FlSpot(4, 4.5),
                      FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: AppColor.primaryColor(context),
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColor.primaryColor(context).withOpacity(0.1),
                    ),
                  ),
                ],
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
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "عرض الكل",
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(color: AppColor.primaryColor(context)),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                      child: Icon(
                        Icons.school_rounded,
                        color: color,
                        size: 20.w,
                      ),
                    ),
                    Gap(12.w),
                    Text(
                      className,
                      style: AppTextStyle.bodyLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
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
