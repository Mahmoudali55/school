import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/domain/services/schedule_pdf_service.dart';

class ScheduleTableBottomSheet extends StatefulWidget {
  final List<ScheduleModel> schedule;
  final String className;
  final TimeOfDay startTime;
  final int periodsCount;
  final int periodDuration;
  final int breakDuration;
  final int thursdayPeriodsCount;
  final int breakAfterPeriod;

  const ScheduleTableBottomSheet({
    super.key,
    required this.schedule,
    required this.className,
    required this.startTime,
    required this.periodsCount,
    required this.periodDuration,
    required this.breakDuration,
    required this.thursdayPeriodsCount,
    required this.breakAfterPeriod,
  });

  @override
  State<ScheduleTableBottomSheet> createState() => _ScheduleTableBottomSheetState();
}

class _ScheduleTableBottomSheetState extends State<ScheduleTableBottomSheet> {
  late final ScrollController _horizontalHeaderController;
  late final ScrollController _horizontalBodyController;
  late final ScrollController _verticalDayController;
  late final ScrollController _verticalBodyController;

  @override
  void initState() {
    super.initState();
    _horizontalHeaderController = ScrollController();
    _horizontalBodyController = ScrollController();
    _verticalDayController = ScrollController();
    _verticalBodyController = ScrollController();

    // Sync horizontal scrolls (Periods)
    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.hasClients) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });

    // Sync vertical scrolls (Days)
    _verticalBodyController.addListener(() {
      if (_verticalDayController.hasClients) {
        _verticalDayController.jumpTo(_verticalBodyController.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalDayController.dispose();
    _verticalBodyController.dispose();
    super.dispose();
  }

  final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  late final List<int> periods;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final maxSlots = widget.periodsCount > widget.thursdayPeriodsCount
        ? widget.periodsCount + 1
        : widget.thursdayPeriodsCount + 1;
    periods = List.generate(maxSlots, (index) => index + 1);
  }

  String _getPeriodTime(int period) {
    int startMins = widget.startTime.hour * 60 + widget.startTime.minute;
    int currentStartMins = startMins;

    for (int i = 1; i < period; i++) {
      if (i == widget.breakAfterPeriod + 1) {
        currentStartMins += widget.breakDuration;
      } else {
        currentStartMins += widget.periodDuration;
      }
    }

    int currentEndMins = currentStartMins;
    if (period == widget.breakAfterPeriod + 1) {
      currentEndMins += widget.breakDuration;
    } else {
      currentEndMins += widget.periodDuration;
    }

    String formatMins(int mins) {
      int h = (mins ~/ 60) % 24;
      int m = mins % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }

    return "${formatMins(currentStartMins)} - ${formatMins(currentEndMins)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          Gap(12.h),
          // Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.grey300Color(context),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Gap(16.h),
          _buildHeader(context),
          Gap(16.h),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColor.surfaceColor(context),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColor.borderColor(context)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Periods Header (Sticky Top)
                  Row(
                    children: [
                      _buildCornerBox(context),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _horizontalHeaderController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: periods
                                .map((p) => _buildPeriodHeaderCell(context, p))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Days Vertical Sticky + Main Grid
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sticky Days Column (Vertical)
                        SingleChildScrollView(
                          controller: _verticalDayController,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: days.map((day) => _buildDayLabelCell(context, day)).toList(),
                          ),
                        ),
                        // Main Scrollable Grid
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _verticalBodyController,
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              controller: _horizontalBodyController,
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: days.map((day) {
                                  return Row(
                                    children: periods.map((period) {
                                      final item = widget.schedule.firstWhere(
                                        (s) => s.day == day && s.period == period,
                                        orElse: () => ScheduleModel(
                                          day: day,
                                          period: period,
                                          subjectName: '',
                                          subjectCode: 0,
                                          teacherName: '',
                                          teacherCode: 0,
                                          classCode: 0,
                                          startTime: '',
                                          endTime: '',
                                        ),
                                      );
                                      return _buildScheduleCell(context, item);
                                    }).toList(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.review_schedule.tr(),
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.w900, fontSize: 22.sp),
              ),
              Text(
                widget.className,
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => SchedulePdfService.generateAndPrint(
                  schedule: widget.schedule,
                  className: widget.className,
                  periodsCount: widget.periodsCount,
                  thursdayPeriodsCount: widget.thursdayPeriodsCount,
                  breakAfterPeriod: widget.breakAfterPeriod,
                ),
                icon: Icon(Icons.print_rounded, color: AppColor.primaryColor(context), size: 24.sp),
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.primaryContainer(context),
                  padding: EdgeInsets.all(10.w),
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColor.primaryContainer(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.watch_later_rounded,
                  color: AppColor.primaryColor(context),
                  size: 28.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCornerBox(BuildContext context) {
    return Container(
      width: 90.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColor.primaryColor(context),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context).withOpacity(0.5)),
          right: BorderSide(color: AppColor.borderColor(context).withOpacity(0.5)),
        ),
      ),
      child: Center(
        child: Text(
          "يوم / حصة",
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.sp),
        ),
      ),
    );
  }

  Widget _buildPeriodHeaderCell(BuildContext context, int period) {
    return Container(
      width: 140.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColor.primaryColor(context),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context).withOpacity(0.5)),
          left: BorderSide(color: AppColor.borderColor(context).withOpacity(0.3)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            period == widget.breakAfterPeriod + 1
                ? "فسحة / Break"
                : "${AppLocalKay.period.tr()} ${period <= widget.breakAfterPeriod ? period : period - 1}",
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11.sp),
          ),
          Text(
            _getPeriodTime(period),
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(color: Colors.white70, fontSize: 9.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabelCell(BuildContext context, String day) {
    return Container(
      width: 90.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColor.grey100Color(context),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context)),
          right: BorderSide(color: AppColor.borderColor(context)),
        ),
      ),
      child: Center(
        child: Text(
          day.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMedium(context).copyWith(
            fontWeight: FontWeight.w900,
            color: AppColor.primaryColor(context),
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCell(BuildContext context, ScheduleModel item) {
    final isEmpty = item.subjectName.isEmpty;
    final isBreak =
        item.subjectName.toLowerCase().contains('break') || item.subjectName.contains('فسحة');
    final colorBase = isBreak ? Colors.brown : _getSubjectColor(context, item.subjectName);

    return Container(
      width: 140.w,
      height: 100.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context).withOpacity(0.5)),
          right: BorderSide(color: AppColor.borderColor(context).withOpacity(0.5)),
        ),
      ),
      child: isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: AppColor.grey50Color(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorBase.withOpacity(0.15), colorBase.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: colorBase.withOpacity(0.2)),
              ),
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isBreak ? Icons.coffee_outlined : _getSubjectIcon(item.subjectName),
                        size: 14.sp,
                        color: colorBase,
                      ),
                      Gap(4.w),
                      Expanded(
                        child: Text(
                          item.subjectName,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodySmall(context).copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorBase.withOpacity(0.8),
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (!isBreak) ...[
                    Gap(6.h),
                    Container(height: 1.h, width: 40.w, color: colorBase.withOpacity(0.1)),
                    Gap(6.h),
                    Text(
                      item.teacherName,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.textSecondary(context),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Color _getSubjectColor(BuildContext context, String subject) {
    final n = subject.toLowerCase();
    if (n.contains('عربي') || n.contains('arabic') || n.contains('لغتي')) return Colors.green;
    if (n.contains('إسلامية') || n.contains('قرآن') || n.contains('دين') || n.contains('islamic'))
      return Colors.teal;
    if (n.contains('math') || n.contains('رياضيات')) return Colors.blue;
    if (n.contains('english') || n.contains('إنجليزي')) return Colors.orange;
    if (n.contains('science') || n.contains('علوم')) return Colors.purple;
    if (n.contains('social') || n.contains('دراسات')) return Colors.amber;
    if (n.contains('art') || n.contains('رسم') || n.contains('فنية')) return Colors.pink;
    if (n.contains('بدنية') || n.contains('pe')) return Colors.cyan;
    if (subject.isEmpty) return Colors.grey;
    return AppColor.primaryColor(context);
  }

  IconData _getSubjectIcon(String subject) {
    final n = subject.toLowerCase();
    if (n.contains('عربي') || n.contains('arabic') || n.contains('لغتي'))
      return Icons.menu_book_rounded;
    if (n.contains('إسلامية') || n.contains('قرآن') || n.contains('دين'))
      return Icons.auto_stories_rounded;
    if (n.contains('math') || n.contains('رياضيات')) return Icons.calculate_rounded;
    if (n.contains('english') || n.contains('إنجليزي')) return Icons.language_rounded;
    if (n.contains('science') || n.contains('علوم')) return Icons.science_rounded;
    if (n.contains('social') || n.contains('دراسات')) return Icons.public_rounded;
    if (n.contains('art') || n.contains('رسم') || n.contains('فنية')) return Icons.palette_rounded;
    if (n.contains('بدنية') || n.contains('pe')) return Icons.sports_soccer_rounded;
    return Icons.school_rounded;
  }
}
