import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/chart_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/pie_chart_placeholder_widget.dart';

class MiniCharts extends StatelessWidget {
  const MiniCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التحليلات السريعة",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChartCard(title: "توزيع الغياب", chart: PieChartPlaceholder()),
              SizedBox(width: 12.w),
              ChartCard(title: "نسب النجاح في المواد", chart: BarChartPlaceholder()),
            ],
          ),
        ),
      ],
    );
  }
}
