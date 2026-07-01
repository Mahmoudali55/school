import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_automatic_call_model.dart';

import 'pick_up_glow_status.dart';
import 'pick_up_status_helper.dart';

class PickUpRequestCard extends StatelessWidget {
  const PickUpRequestCard({super.key, required this.request});

  final AutomaticCallItem request;

  String get _initials {
    final name = request.studentname.trim();
    if (name.isEmpty) return '?';
    return name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = PickUpStatusHelper.colorOf(request.flag, context);
    final statusText = PickUpStatusHelper.textOf(request.flag);

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor(context).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColor.borderColor(context),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left Stripe Color Indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5.w,
              color: statusColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Avatar(initials: _initials, color: statusColor),
                    Gap(14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.studentname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.bodyLarge(context).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                            ),
                          ),
                          Gap(4.h),
                          _StudentCodeChip(code: request.studentcode.toString() ),
                        ],
                      ),
                    ),
                    PickUpGlowStatus(color: statusColor, text: statusText),
                  ],
                ),
                if (request.notes.isNotEmpty) ...[
                  Gap(12.h),
                  _NotesBox(notes: request.notes),
                ],
                Gap(12.h),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColor.dividerColor(context).withValues(alpha: 0.4),
                ),
                Gap(10.h),
                _CardFooter(transDate: request.transdate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.r,
      width: 52.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyle.titleMedium(context).copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}

class _StudentCodeChip extends StatelessWidget {
  const _StudentCodeChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_outlined,
            size: 11.r,
            color: AppColor.textColor(context).withValues(alpha: 0.55),
          ),
          Gap(4.w),
          Text(
            "${AppLocalKay.code.tr()} : $code",
            style: AppTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 9.sp,
              color: AppColor.textColor(context).withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesBox extends StatelessWidget {
  const _NotesBox({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.speaker_notes_outlined,
            size: 12.r,
            color: AppColor.textColor(context).withValues(alpha: 0.6),
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              notes,
              style: AppTextStyle.bodySmall(context).copyWith(
                height: 1.3,
                color: AppColor.textColor(context).withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.transDate});

  final String transDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 13.r,
          color: AppColor.textColor(context).withValues(alpha: 0.4),
        ),
        Gap(6.w),
        Text(
          PickUpStatusHelper.formatTime(transDate),
          style: AppTextStyle.bodySmall(context).copyWith(
            color: AppColor.textColor(context).withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppColor.errorColor(context).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            AppLocalKay.URGENT.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(
              fontSize: 9.sp,
              fontWeight: FontWeight.w900,
              color: AppColor.errorColor(context),
            ),
          ),
        ),
      ],
    );
  }
}
