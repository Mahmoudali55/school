import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PieChartPlaceholder extends StatelessWidget {
  const PieChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: Colors.green[100],
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
      color: Colors.purple[100],
      child: Center(child: Text("Bar Chart")),
    );
  }
}
