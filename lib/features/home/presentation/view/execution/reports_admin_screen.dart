import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class ReportsAdminScreen extends StatelessWidget {
  ReportsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير والإحصائيات'), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.5,
              ),
              itemCount: _reportTypes.length,
              itemBuilder: (context, index) {
                final report = _reportTypes[index];
                return Card(
                  elevation: 2,
                  color: report['color']!.withOpacity(0.1),
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(report['icon'], color: report['color'], size: 32.sp),
                        SizedBox(height: 8.h),
                        Text(
                          report['title']!,
                          style: AppTextStyle.titleSmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold, color: report['color']),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقارير الحديثة',
                    style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _recentReports.length,
                      itemBuilder: (context, index) {
                        final report = _recentReports[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            title: Text(report['title']!),
                            subtitle: Text(report['date']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.download, color: Colors.orange),
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _reportTypes = [
    {'title': 'تقارير الحضور', 'icon': Icons.check_box_outline_blank, 'color': Colors.blue},
    {'title': 'التقارير المالية', 'icon': Icons.payments, 'color': Colors.green},
    {'title': 'نتائج الطلاب', 'icon': Icons.grade, 'color': Colors.orange},
    {'title': 'تقارير المعلمين', 'icon': Icons.people, 'color': Colors.purple},
  ];

  final List<Map<String, String>> _recentReports = [
    {'title': 'تقرير الحضور الشهري', 'date': '2024-12-01'},
    {'title': 'التقرير المالي نوفمبر', 'date': '2024-11-28'},
    {'title': 'نتائج الفصل الأول', 'date': '2024-11-20'},
  ];
}
