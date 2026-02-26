import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';

class InteractiveScheduleTable extends StatefulWidget {
  final String className;
  final TimeOfDay startTime;
  final int periodsCount;
  final int periodDuration;
  final int breakDuration;
  final int thursdayPeriodsCount;
  final int breakAfterPeriod;
  final int classCode;
  final bool isReadOnly;

  const InteractiveScheduleTable({
    super.key,
    required this.className,
    required this.startTime,
    required this.periodsCount,
    required this.periodDuration,
    required this.breakDuration,
    required this.thursdayPeriodsCount,
    required this.breakAfterPeriod,
    required this.classCode,
    this.isReadOnly = false,
  });

  @override
  State<InteractiveScheduleTable> createState() => _InteractiveScheduleTableState();
}

class _InteractiveScheduleTableState extends State<InteractiveScheduleTable> {
  late final ScrollController _horizontalHeaderController;
  late final ScrollController _horizontalBodyController;
  late final ScrollController _verticalDayController;
  late final ScrollController _verticalBodyController;

  ScheduleModel? _draggedItem;

  @override
  void initState() {
    super.initState();
    _horizontalHeaderController = ScrollController();
    _horizontalBodyController = ScrollController();
    _verticalDayController = ScrollController();
    _verticalBodyController = ScrollController();

    // Sync horizontal scrolls
    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.hasClients) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });

    // Sync vertical scrolls
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

  (String, String) _getPeriodStartAndEndTime(int period) {
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

    return (formatMins(currentStartMins), formatMins(currentEndMins));
  }

  String _getPeriodTime(int period) {
    final (start, end) = _getPeriodStartAndEndTime(period);
    return "$start - $end";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Defensive check for zero or very small constraints during rotation/transitions
        if (constraints.maxWidth < 100 || constraints.maxHeight < 100) {
          return const Center(child: CircularProgressIndicator());
        }

        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;

        // Responsive sizes with safe minimums
        final dayWidth = (80.w).clamp(70.0, 100.0);
        final cellWidth = isLandscape ? (120.w).clamp(110.0, 150.0) : (140.w).clamp(130.0, 180.0);
        final headerHeight = isLandscape ? (35.h).clamp(30.0, 45.0) : (40.h).clamp(35.0, 50.0);
        final cellHeight = isLandscape ? (80.h).clamp(70.0, 120.0) : (100.h).clamp(90.0, 150.0);

        return BlocListener<ScheduleCubit, ScheduleState>(
          listenWhen: (prev, curr) => prev.validationStatus != curr.validationStatus,
          listener: (context, state) {
            if (state.validationStatus.isFailure) {
              CommonMethods.showToast(message: state.validationStatus.error ?? "");
            }
          },
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              final schedule = state.generatedSchedules;
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.surfaceColor(context),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: AppColor.borderColor(context)),
                ),
                clipBehavior: Clip
                    .hardEdge, // Changed from antiAlias to hardEdge for performance during resize
                child: Column(
                  children: [
                    // Periods Header (Sticky Top)
                    Row(
                      children: [
                        _buildCornerBox(context, dayWidth, headerHeight),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _horizontalHeaderController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Row(
                              children: periods
                                  .map(
                                    (p) =>
                                        _buildPeriodHeaderCell(context, p, cellWidth, headerHeight),
                                  )
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
                              children: days
                                  .map(
                                    (day) => _buildDayLabelCell(context, day, dayWidth, cellHeight),
                                  )
                                  .toList(),
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
                                        final (st, et) = _getPeriodStartAndEndTime(period);
                                        final isBreakSlot = period == widget.breakAfterPeriod + 1;
                                        final searchPeriod = isBreakSlot
                                            ? 0
                                            : (period > widget.breakAfterPeriod + 1
                                                  ? period - 1
                                                  : period);
                                        final item = schedule.firstWhere(
                                          (s) => s.day == day && s.period == searchPeriod,
                                          orElse: () => ScheduleModel(
                                            day: day,
                                            period: period,
                                            subjectName: '',
                                            subjectCode: 0,
                                            teacherName: '',
                                            teacherCode: 0,
                                            classCode: widget.classCode,
                                            startTime: st,
                                            endTime: et,
                                          ),
                                        );
                                        return _buildDraggableScheduleCell(
                                          context,
                                          item,
                                          cellWidth,
                                          cellHeight,
                                        );
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
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCornerBox(BuildContext context, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.primaryColor(context).withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context)),
          right: BorderSide(color: AppColor.borderColor(context)),
        ),
      ),
      child: Center(
        child: Text(
          'اليوم',
          style: AppTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPeriodHeaderCell(BuildContext context, int period, double width, double height) {
    final isBreak = period == widget.breakAfterPeriod + 1;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isBreak
            ? Colors.orange.withValues(alpha: 0.1)
            : AppColor.primaryColor(context).withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context)),
          right: BorderSide(color: AppColor.borderColor(context)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isBreak
                ? 'فسحة'
                : 'الحصة ${period > widget.breakAfterPeriod + 1 ? period - 1 : period}',
            style: AppTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              color: isBreak ? Colors.orange.shade800 : AppColor.primaryColor(context),
            ),
          ),
          Text(
            _getPeriodTime(period),
            style: AppTextStyle.bodySmall(context).copyWith(fontSize: 9.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabelCell(BuildContext context, String day, double width, double height) {
    final Map<String, String> dayNamesAr = {
      'Sunday': 'الأحد',
      'Monday': 'الاثنين',
      'Tuesday': 'الثلاثاء',
      'Wednesday': 'الأربعاء',
      'Thursday': 'الخميس',
    };
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context)),
          right: BorderSide(color: AppColor.borderColor(context)),
        ),
      ),
      child: Center(
        child: Text(
          dayNamesAr[day] ?? day,
          style: AppTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDraggableScheduleCell(
    BuildContext context,
    ScheduleModel item,
    double width,
    double height,
  ) {
    if (widget.isReadOnly) {
      return _buildScheduleCell(context, item, width, height);
    }

    final isBreak =
        item.subjectName.toLowerCase().contains('break') || item.subjectName.contains('فسحة');

    if (isBreak || item.subjectName.isEmpty) {
      return DragTarget<ScheduleModel>(
        onWillAccept: (data) => data != null && !isBreak,
        onAccept: (data) {
          if (data != item) {
            context.read<ScheduleCubit>().swapPeriods(data, item);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Opacity(
            opacity: candidateData.isNotEmpty ? 0.6 : 1.0,
            child: _buildScheduleCell(context, item, width, height),
          );
        },
      );
    }

    return LongPressDraggable<ScheduleModel>(
      data: item,
      delay: const Duration(milliseconds: 200),
      onDragStarted: () {
        HapticFeedback.heavyImpact();
        setState(() => _draggedItem = item);
      },
      onDragEnd: (_) {
        setState(() => _draggedItem = null);
      },
      onDraggableCanceled: (_, __) {
        setState(() => _draggedItem = null);
      },
      onDragCompleted: () {
        setState(() => _draggedItem = null);
      },
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.transparent,
        child: SizedBox(
          width: width,
          height: height,
          child: _buildScheduleCell(context, item, width, height),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildScheduleCell(context, item, width, height),
      ),
      child: DragTarget<ScheduleModel>(
        onWillAccept: (data) => data != null && data != item,
        onAccept: (data) {
          context.read<ScheduleCubit>().swapPeriods(data, item);
        },
        builder: (context, candidateData, rejectedData) {
          return Opacity(
            opacity: candidateData.isNotEmpty ? 0.6 : 1.0,
            child: BlocBuilder<ScheduleCubit, ScheduleState>(
              buildWhen: (prev, curr) => prev.selectedSlot != curr.selectedSlot,
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => _showSwapSelectionMenu(context, item, state.generatedSchedules),
                  child: _buildScheduleCell(context, item, width, height, state.selectedSlot),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showSwapSelectionMenu(
    BuildContext context,
    ScheduleModel currentItem,
    List<ScheduleModel> allSchedules,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<ScheduleCubit>(),
          child: Builder(
            builder: (sheetContentContext) {
              final List<ScheduleModel> otherSlots = [];
              final daysOrder = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

              for (var day in daysOrder) {
                final dayPeriods = allSchedules.where((s) => s.day == day).toList();
                dayPeriods.sort((a, b) => a.period.compareTo(b.period));
                for (var p in dayPeriods) {
                  final isBreak =
                      p.subjectName.toLowerCase().contains('break') ||
                      p.subjectName.contains('فسحة');
                  if (!isBreak && p != currentItem) {
                    otherSlots.add(p);
                  }
                }
              }

              return Container(
                height: 0.7.sh,
                decoration: BoxDecoration(
                  color: AppColor.surfaceColor(sheetContentContext),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: Column(
                  children: [
                    Gap(12.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColor.borderColor(sheetContentContext),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Gap(16.h),
                    Text(
                      'تبديل " ${currentItem.subjectName.isEmpty ? 'حصة فارغة' : currentItem.subjectName} " مع ...',
                      style: AppTextStyle.titleMedium(
                        sheetContentContext,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Gap(16.h),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        itemCount: otherSlots.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1.h,
                          color: AppColor.borderColor(sheetContentContext).withValues(alpha: 0.5),
                        ),
                        itemBuilder: (itemContext, index) {
                          final target = otherSlots[index];
                          final dayAr =
                              {
                                'Sunday': 'الأحد',
                                'Monday': 'الاثنين',
                                'Tuesday': 'الثلاثاء',
                                'Wednesday': 'الأربعاء',
                                'Thursday': 'الخميس',
                              }[target.day] ??
                              target.day;

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                            leading: Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor(itemContext).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text(
                                  '${target.period}',
                                  style: AppTextStyle.bodySmall(itemContext).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryColor(itemContext),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              target.subjectName.isEmpty ? 'حصة فارغة' : target.subjectName,
                              style: AppTextStyle.bodyMedium(itemContext).copyWith(
                                fontWeight: target.subjectName.isNotEmpty
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              '$dayAr - ${target.teacherName.isEmpty ? 'بدون معلم' : target.teacherName}',
                              style: AppTextStyle.bodySmall(
                                itemContext,
                              ).copyWith(color: Colors.grey),
                            ),
                            trailing: Icon(
                              Icons.swap_horiz_rounded,
                              color: AppColor.primaryColor(itemContext),
                            ),
                            onTap: () {
                              context.read<ScheduleCubit>().swapPeriods(currentItem, target);
                              Navigator.pop(bottomSheetContext);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildScheduleCell(
    BuildContext context,
    ScheduleModel item,
    double width,
    double height, [
    ScheduleModel? selectedSlot,
  ]) {
    final isEmpty = item.subjectName.isEmpty;
    final isBreak =
        item.subjectName.toLowerCase().contains('break') || item.subjectName.contains('فسحة');

    final isSelected = selectedSlot == item;
    final isTarget =
        (selectedSlot != null || _draggedItem != null) &&
        !isBreak &&
        !isSelected &&
        (selectedSlot != item && _draggedItem != item);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isBreak
            ? Colors.orange.shade50
            : isSelected
            ? AppColor.primaryColor(context).withValues(alpha: 0.1)
            : AppColor.whiteColor(context),
        border: Border.all(
          color: isSelected
              ? AppColor.primaryColor(context)
              : isTarget
              ? AppColor.primaryColor(context).withValues(alpha: 0.5)
              : AppColor.borderColor(context),
          width: isSelected ? 2.w : (isTarget ? 1.5.w : 0.5.w),
        ),
        boxShadow: (isSelected || isTarget)
            ? [
                BoxShadow(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.2),
                  blurRadius: isSelected ? 8 : 4,
                  spreadRadius: isSelected ? 2 : 1,
                ),
              ]
            : null,
      ),
      child: isEmpty
          ? Center(
              child: Container(
                width: 30.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.borderColor(context),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.subjectName,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: AppColor.primaryColor(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isBreak) ...[
                  Gap(4.h),
                  Text(
                    item.teacherName,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontSize: 9.sp, color: AppColor.grey600Color(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.room != null && item.room!.isNotEmpty)
                    Text(
                      item.room!,
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(fontSize: 8.sp, color: AppColor.grey400Color(context)),
                    ),
                ],
              ],
            ),
    );
  }
}
