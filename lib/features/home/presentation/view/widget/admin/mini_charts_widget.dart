import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class MiniCharts extends StatelessWidget {
  const MiniCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quickAnalysis.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 180.w,
                child: ChartCard(
                  title: AppLocalKay.absenceDistribution.tr(),
                  chart: _buildPieChart(),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 180.w,
                child: ChartCard(
                  title: AppLocalKay.successDistribution.tr(),
                  chart: _buildBarChart(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Colors.green, title: "حاضر"),
          PieChartSectionData(value: 30, color: Colors.red, title: "غائب"),
          PieChartSectionData(value: 30, color: Colors.orange, title: "متأخر"),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 20,
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 100,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 90, color: Colors.blue)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 75, color: Colors.blue)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 85, color: Colors.blue)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 70, color: Colors.blue)]),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ["رياضيات", "عربية", "علوم", "إنجليزي"];
                return Text(
                  labels[value.toInt()],
                  style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  const ChartCard({super.key, required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            SizedBox(height: 100.h, child: chart),
          ],
        ),
      ),
    );
  }
}
