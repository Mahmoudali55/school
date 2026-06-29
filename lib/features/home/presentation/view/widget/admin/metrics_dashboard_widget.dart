import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/metric_card_model.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/metric_card_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/widgets/dashboard_section_header.dart';

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
          change: data['change'] ?? "",
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
        DashboardSectionHeader(
          title: AppLocalKay.generalView.tr(),
        ),
        Gap(16.h),
        SizedBox(
          height:MediaQuery.sizeOf(context).height * 0.15,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: metrics.length,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            separatorBuilder: (_, __) => Gap(16.w),
            itemBuilder: (context, index) => MetricCardWidget(metric: metrics[index]),
          ),
        ),
      ],
    );
  }
}
