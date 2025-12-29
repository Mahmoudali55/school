import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/execution/chart_detail_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = 'هذا الشهر';
  String _selectedReportType = 'الكل';

  final List<String> _periods = ['اليوم', 'هذا الأسبوع', 'هذا الشهر', 'هذا الفصل', 'هذه السنة'];
  final List<String> _reportTypes = ['الكل', 'الحضور', 'الدرجات', 'السلوك', 'المالي'];

  final List<Map<String, dynamic>> _quickStats = [
    {
      'title': 'الحضور',
      'value': '94%',
      'icon': Icons.calendar_today,
      'color': Colors.green,
      'trend': '↑ 2%',
    },
    {
      'title': 'الدرجات',
      'value': '86%',
      'icon': Icons.grade,
      'color': Colors.blue,
      'trend': '↑ 1.5%',
    },
    {
      'title': 'الطلاب',
      'value': '1,200',
      'icon': Icons.people,
      'color': Colors.orange,
      'trend': '↑ 5%',
    },
    {
      'title': 'المعلمين',
      'value': '85',
      'icon': Icons.school,
      'color': Colors.purple,
      'trend': '↑ 2%',
    },
  ];

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'تقرير الحضور الشهري',
      'type': 'الحضور',
      'date': 'منذ 2 ساعة',
      'status': 'مكتمل',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
    },
    {
      'title': 'نتائج الاختبار النهائي',
      'type': 'الدرجات',
      'date': 'منذ 6 ساعات',
      'status': 'مكتمل',
      'icon': Icons.grade,
      'color': Colors.green,
    },
    {
      'title': 'تقرير السلوك الأسبوعي',
      'type': 'السلوك',
      'date': 'منذ يوم',
      'status': 'مكتمل',
      'icon': Icons.psychology,
      'color': Colors.orange,
    },
    {
      'title': 'بيان المصروفات',
      'type': 'المالي',
      'date': 'منذ يومين',
      'status': 'مكتمل',
      'icon': Icons.attach_money,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.reports_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الإحصائيات السريعة
            _buildQuickStats(),
            SizedBox(height: 24.h),

            // الفلاتر
            _buildFilters(),
            SizedBox(height: 24.h),

            // التقارير الحديثة
            _buildRecentReports(),
            SizedBox(height: 24.h),

            // الرسوم البيانية
            _buildChartsSection(),
            SizedBox(height: 20.h), // مسافة إضافية في الأسفل
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.user_management_quick_report.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        SizedBox(height: 16.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1,
          ),
          itemCount: _quickStats.length,
          itemBuilder: (context, index) {
            final stat = _quickStats[index];
            return _buildStatCard(stat);
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8.r, offset: Offset(0, 2.h)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: stat['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(stat['icon'] as IconData, color: stat['color'] as Color, size: 20.w),
                ),
                SizedBox(width: 8.w),
                Text(
                  stat['trend'] as String,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat['value'] as String,
                  style: AppTextStyle.headlineLarge(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                SizedBox(height: 4.h),
                Text(
                  stat['title'] as String,
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.user_management_clear_reports.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        SizedBox(height: 16.h),

        Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // نوع التقرير
                Row(
                  children: [
                    Icon(Icons.filter_list, size: 18.w, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalKay.user_management_report_type.tr(),
                      style: AppTextStyle.titleSmall(context),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _reportTypes.map((type) {
                    final isSelected = _selectedReportType == type;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedReportType = type;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          type,
                          style: AppTextStyle.bodySmall(context).copyWith(
                            color: isSelected ? AppColor.whiteColor(context) : Colors.grey.shade700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 16.h),
                Divider(),
                SizedBox(height: 16.h),

                // الفترة الزمنية
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalKay.user_management_report_period.tr(),
                            style: AppTextStyle.titleSmall(context),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPeriod,
                                isExpanded: true,
                                items: _periods.map((period) {
                                  return DropdownMenuItem(
                                    value: period,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      child: Text(period),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPeriod = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // زر التصدير
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' ', style: AppTextStyle.bodyMedium(context)),
                          SizedBox(height: 8.h),
                          ElevatedButton.icon(
                            onPressed: _exportReport,
                            icon: Icon(Icons.picture_as_pdf, size: 16.w),
                            label: Text(
                              AppLocalKay.user_management_export_pdf.tr(),
                              style: AppTextStyle.bodySmall(context),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: AppColor.whiteColor(context),
                              minimumSize: Size.fromHeight(44.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.user_management_no_reports.tr(),
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            TextButton(
              onPressed: () {},
              child: Text(AppLocalKay.show_all.tr(), style: AppTextStyle.bodySmall(context)),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Column(
          children: _reports.map((report) {
            return _buildReportItem(report);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8.r, offset: Offset(0, 2.h)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: report['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(report['icon'] as IconData, color: report['color'] as Color, size: 20.w),
        ),
        title: Text(report['title'] as String, style: AppTextStyle.titleSmall(context)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            Text(
              report['date'] as String,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 11.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: report['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                report['type'] as String,
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontSize: 10.sp,
                  color: report['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              report['status'] as String,
              style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: Colors.green),
            ),
          ],
        ),
        onTap: () {
          // عرض التقرير
        },
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.user_management_fees.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        SizedBox(height: 16.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: .75,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final charts = [
              {'title': 'الحضور', 'color': Colors.blue, 'icon': Icons.calendar_today},
              {'title': 'الدرجات', 'color': Colors.green, 'icon': Icons.grade},
              {'title': 'المالي', 'color': Colors.orange, 'icon': Icons.attach_money},
              {'title': 'السلوك', 'color': Colors.purple, 'icon': Icons.psychology},
            ];
            return _buildChartCard(charts[index]);
          },
        ),
      ],
    );
  }

  // أضف في الأعلى مع باقي ال

  // ثم عدل دالة _buildChartCard كالتالي:
  Widget _buildChartCard(Map<String, dynamic> chart) {
    // تحديد نوع الرسم البياني بناءً على العنوان
    String chartType = 'attendance';
    if (chart['title'] == 'الدرجات') chartType = 'grades';
    if (chart['title'] == 'المالي') chartType = 'financial';
    if (chart['title'] == 'السلوك') chartType = 'behavior';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChartDetailPage(
              chartTitle: chart['title'] as String,
              chartColor: chart['color'] as Color,
              chartType: chartType,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: chart['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      chart['icon'] as IconData,
                      color: chart['color'] as Color,
                      size: 16.w,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.bar_chart, size: 16.w, color: Colors.grey),
                ],
              ),

              SizedBox(height: 8.h),

              Text(
                chart['title'] as String,
                style: AppTextStyle.titleSmall(
                  context,
                ).copyWith(fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              ),

              SizedBox(height: 8.h),

              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(Icons.bar_chart, size: 24.w, color: chart['color'].withOpacity(0.3)),
                ),
              ),

              SizedBox(height: 8.h),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChartDetailPage(
                        chartTitle: chart['title'] as String,
                        chartColor: chart['color'] as Color,
                        chartType: chartType,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppLocalKay.user_management_view_chart.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(color: chart['color'] as Color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('جاري تصدير التقرير...'), backgroundColor: Colors.blue));
  }
}
