// features/reports/presentation/view/chart_detail_page.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

class ChartDetailPage extends StatefulWidget {
  final String chartTitle;
  final Color chartColor;
  final String chartType;

  const ChartDetailPage({
    super.key,
    required this.chartTitle,
    required this.chartColor,
    required this.chartType,
  });

  @override
  State<ChartDetailPage> createState() => _ChartDetailPageState();
}

class _ChartDetailPageState extends State<ChartDetailPage> {
  String _selectedTimeRange = 'هذا الشهر';
  String _selectedChartStyle = 'شريطي';
  int _touchedIndex = -1;

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
          widget.chartTitle,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartControls(),
            SizedBox(height: 20.h),
            _buildMainChart(),
            SizedBox(height: 20.h),
            _buildDetailedStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartControls() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الفترة:',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButton<String>(
                        value: _selectedTimeRange,
                        isExpanded: true,
                        items: [
                          'هذا الأسبوع',
                          'هذا الشهر',
                          'هذا الفصل',
                          'هذه السنة',
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeRange = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النوع:',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButton<String>(
                        value: _selectedChartStyle,
                        isExpanded: true,
                        items: [
                          'شريطي',
                          'خطي',
                          'دائري',
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedChartStyle = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرسم البياني التفصيلي',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'بيانات ${widget.chartTitle} للفترة المحددة',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 16.h),
            // استخدام Container قابل للتمرير أفقيًا
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: _getChartWidth(), // عرض ديناميكي بناءً على عدد العناصر
                height: 350.h,
                padding: EdgeInsets.all(16.w),
                child: _buildFlChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlChart() {
    switch (_selectedChartStyle) {
      case 'شريطي':
        return BarChart(_buildBarChartData());
      case 'خطي':
        return LineChart(_buildLineChartData());
      case 'دائري':
        return PieChart(_buildPieChartData());
      default:
        return BarChart(_buildBarChartData());
    }
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.white,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toInt()}%\n${_getBarTitles()[group.x.toInt()]}',
              TextStyle(color: widget.chartColor, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.h, // زيادة المساحة للعناوين
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < _getBarTitles().length) {
                return Padding(
                  padding: EdgeInsets.only(top: 12.h), // زيادة المسافة العلوية
                  child: SizedBox(
                    width: 80.w, // عرض ثابت لكل عنوان
                    child: Text(
                      _getBarTitles()[index],
                      style: TextStyle(
                        fontSize: 12.sp, // زيادة حجم الخط
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.w, // زيادة المساحة للمحور اليساري
            interval: 20,
            getTitlesWidget: (value, meta) {
              if (value % 20 == 0) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      barGroups: _getBarData(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
        },
      ),
      // إعدادات إضافية لتحسين المساحة
      groupsSpace: 6.w, // زيادة المسافة بين الأعمدة
    );
  }

  List<String> _getBarTitles() {
    switch (widget.chartType) {
      case 'attendance':
        return ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
      case 'grades':
        return ['الرياضيات', 'العربية', 'الإنجليزية', 'العلوم', 'الاجتماعيات', 'التربية الإسلامية'];
      case 'financial':
        return [
          'الرسوم الدراسية',
          'المصروفات',
          'الأنشطة',
          'النقل المدرسي',
          'الزي المدرسي',
          'الكتب',
        ];
      default:
        return ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
    }
  }

  List<BarChartGroupData> _getBarData() {
    final data = _getChartData();
    final titles = _getBarTitles();

    return List.generate(data.length, (index) {
      final isTouched = index == _touchedIndex;
      final radius = isTouched ? 8.0 : 4.0;

      return BarChartGroupData(
        x: index,
        groupVertically: true,
        barRods: [
          BarChartRodData(
            toY: data[index],
            color: isTouched ? widget.chartColor.withOpacity(0.8) : widget.chartColor,
            width: 28.w, // زيادة عرض الأعمدة
            borderRadius: BorderRadius.circular(radius),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.grey.shade100,
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    });
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.white,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              return LineTooltipItem(
                '${touchedSpot.y.toInt()}%',
                TextStyle(color: widget.chartColor, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.h,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < _getLineTitles().length) {
                return SizedBox(
                  width: 80.w,
                  child: Text(
                    _getLineTitles()[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.w,
            interval: 20,
            getTitlesWidget: (value, meta) {
              if (value % 20 == 0) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Text(
                    '${value.toInt()}%',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _getLineSpots(),
          isCurved: true,
          color: widget.chartColor,
          barWidth: 4.w,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5.r,
                color: widget.chartColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: true, color: widget.chartColor.withOpacity(0.2)),
        ),
      ],
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
        },
      ),
      minY: 0,
      maxY: 100,
    );
  }

  List<String> _getLineTitles() {
    return ['الأسبوع 1', 'الأسبوع 2', 'الأسبوع 3', 'الأسبوع 4'];
  }

  List<FlSpot> _getLineSpots() {
    final data = _getChartData();
    final limitedData = data.length > 4 ? data.sublist(0, 4) : data;
    return List.generate(limitedData.length, (index) {
      return FlSpot(index.toDouble(), limitedData[index]);
    });
  }

  PieChartData _buildPieChartData() {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              _touchedIndex = -1;
              return;
            }
            _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      sectionsSpace: 4.r,
      centerSpaceRadius: 80.r, // زيادة مساحة المركز
      sections: _getPieSections(),
    );
  }

  List<PieChartSectionData> _getPieSections() {
    final data = _getChartData();
    final total = data.reduce((a, b) => a + b);

    return List.generate(data.length, (i) {
      final isTouched = i == _touchedIndex;
      final radius = isTouched ? 75.0 : 65.0;
      final fontSize = isTouched ? 14.0 : 12.0;

      return PieChartSectionData(
        color: _getPieColors()[i % _getPieColors().length],
        value: data[i],
        title: '${((data[i] / total) * 100).toStringAsFixed(1)}%',
        radius: radius.r,
        titleStyle: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4.r)],
                ),
                child: Text(
                  _getPieTitles()[i],
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: _getPieColors()[i % _getPieColors().length],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      );
    });
  }

  List<Color> _getPieColors() {
    return [
      widget.chartColor,
      widget.chartColor.withOpacity(0.8),
      widget.chartColor.withOpacity(0.6),
      widget.chartColor.withOpacity(0.4),
      widget.chartColor.withOpacity(0.3),
      widget.chartColor.withOpacity(0.2),
    ];
  }

  List<String> _getPieTitles() {
    switch (widget.chartType) {
      case 'attendance':
        return ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
      case 'grades':
        return ['الرياضيات', 'العربية', 'الإنجليزية', 'العلوم', 'الاجتماعيات', 'التربية'];
      case 'financial':
        return ['الرسوم', 'المصروفات', 'الأنشطة', 'النقل', 'الزي', 'الكتب'];
      default:
        return ['قسم 1', 'قسم 2', 'قسم 3', 'قسم 4'];
    }
  }

  List<double> _getChartData() {
    switch (widget.chartType) {
      case 'attendance':
        return [95.0, 92.0, 94.0, 96.0, 93.0, 90.0];
      case 'grades':
        return [88.0, 85.0, 92.0, 78.0, 90.0, 86.0];
      case 'financial':
        return [45.0, 25.0, 15.0, 8.0, 5.0, 2.0];
      default:
        return [80.0, 85.0, 90.0, 75.0];
    }
  }

  // دالة لحساب العرض الديناميكي للرسم البياني
  double _getChartWidth() {
    final numberOfItems = _getBarTitles().length;
    final baseWidth = 90.w; // عرض لكل عمود
    final minWidth = MediaQuery.of(context).size.width - 32.w; // 32 padding
    return (numberOfItems * baseWidth) + 32.w > minWidth
        ? (numberOfItems * baseWidth) + 32.w
        : minWidth;
  }

  Widget _buildDetailedStats() {
    List<Map<String, dynamic>> statsData = _getStatsData();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإحصائيات التفصيلية',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Column(
              children: statsData.map((stat) {
                return _buildStatRow(stat);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(Map<String, dynamic> stat) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: widget.chartColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(stat['icon'] as IconData, size: 18.w, color: widget.chartColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat['title'] as String,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  stat['subtitle'] as String,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            stat['value'] as String,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: widget.chartColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getStatsData() {
    switch (widget.chartType) {
      case 'attendance':
        return [
          {
            'title': 'متوسط الحضور',
            'subtitle': 'إجمالي الطلاب',
            'value': '94%',
            'icon': Icons.people,
          },
          {
            'title': 'أعلى حضور',
            'subtitle': 'الصف العاشر',
            'value': '98%',
            'icon': Icons.trending_up,
          },
          {
            'title': 'أقل حضور',
            'subtitle': 'الصف السابع',
            'value': '87%',
            'icon': Icons.trending_down,
          },
        ];

      case 'grades':
        return [
          {
            'title': 'المتوسط العام',
            'subtitle': 'جميع المواد',
            'value': '86%',
            'icon': Icons.grade,
          },
          {
            'title': 'أعلى درجة',
            'subtitle': 'مادة الرياضيات',
            'value': '95%',
            'icon': Icons.emoji_events,
          },
          {
            'title': 'أقل درجة',
            'subtitle': 'مادة اللغة الإنجليزية',
            'value': '78%',
            'icon': Icons.warning,
          },
        ];

      case 'financial':
        return [
          {
            'title': 'الإيرادات',
            'subtitle': 'هذا الشهر',
            'value': '125,000 ر.س',
            'icon': Icons.arrow_upward,
          },
          {
            'title': 'المصروفات',
            'subtitle': 'هذا الشهر',
            'value': '85,000 ر.س',
            'icon': Icons.arrow_downward,
          },
          {
            'title': 'صافي الربح',
            'subtitle': 'هذا الشهر',
            'value': '40,000 ر.س',
            'icon': Icons.account_balance,
          },
        ];

      default:
        return [
          {
            'title': 'القيمة الإجمالية',
            'subtitle': 'المجموع',
            'value': '100%',
            'icon': Icons.analytics,
          },
        ];
    }
  }
}
