import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/domain/services/schedule_pdf_service.dart';
import 'package:my_template/features/class/presentation/execution/widget/interactive_schedule_table.dart';

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
    required this.classCode,
  });

  final int classCode;

  @override
  State<ScheduleTableBottomSheet> createState() => _ScheduleTableBottomSheetState();
}

class _ScheduleTableBottomSheetState extends State<ScheduleTableBottomSheet> {
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: InteractiveScheduleTable(
                className: widget.className,
                startTime: widget.startTime,
                periodsCount: widget.periodsCount,
                periodDuration: widget.periodDuration,
                breakDuration: widget.breakDuration,
                thursdayPeriodsCount: widget.thursdayPeriodsCount,
                breakAfterPeriod: widget.breakAfterPeriod,
                classCode: widget.classCode,
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
}
