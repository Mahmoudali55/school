import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class PieChartPlaceholder extends StatelessWidget {
  const PieChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: AppColor.successColor(context).withValues(alpha: 0.1),
      child: Center(child: Text("Pie Chart")),
    );
  }
}

class BarChartPlaceholder extends StatelessWidget {
  const BarChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: AppColor.primaryColor(context).withValues(alpha: 0.1),
      child: Center(child: Text("Bar Chart")),
    );
  }
}
