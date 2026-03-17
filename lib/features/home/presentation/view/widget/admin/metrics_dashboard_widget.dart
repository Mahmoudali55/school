import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/metric_card_model.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/metric_card_widget.dart';

class MetricsDashboard extends StatelessWidget {
  final Map<String, Map<String, dynamic>> metricsData;

  const MetricsDashboard({super.key, required this.metricsData});

  List<MetricCard> _buildMetrics() {
    final List<MetricCard> list = [];

    metricsData.forEach((key, data) {
      IconData icon = data['icon'] ?? Icons.info;
      Color color = data['color'] ?? Colors.blue;

      list.add(
        MetricCard(
          title: key,
          value: data['value'] ?? "0",
          change: data['change'] ?? "0",
          isPositive: data['isPositive'] ?? true,
          icon: icon,
          color: color,
        ),
      );
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _buildMetrics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.generalView.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Gap(12.h),
        SizedBox(
          height: 150.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: metrics.length,
            separatorBuilder: (_, __) => Gap(12.w),
            itemBuilder: (context, index) => MetricCardWidget(metric: metrics[index]),
          ),
        ),
      ],
    );
  }
}
