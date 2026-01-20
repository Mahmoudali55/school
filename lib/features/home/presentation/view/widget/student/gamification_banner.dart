import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class GamificationBanner extends StatelessWidget {
  final int points;
  final int level;
  final List<String> badges;

  const GamificationBanner({
    super.key,
    required this.points,
    required this.level,
    this.badges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLevelBadge(context),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalKay.point.tr(),
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      color: AppColor.whiteColor(context).withValues(alpha: (0.9)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${AppLocalKay.level.tr()} $level",
                    style: AppTextStyle.titleLarge(
                      context,
                    ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  _buildProgressIndicator(context),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            _buildPointsDisplay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.4), width: 2),
      ),
      child: Center(
        child: Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 30.w),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    double progress = (points % 100) / 100.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColor.whiteColor(context).withValues(alpha: (0.2)),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "${100 - (points % 100)} ${AppLocalKay.next_level.tr()}",
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(color: AppColor.whiteColor(context).withValues(alpha: 0.8), fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildPointsDisplay(BuildContext context) {
    return Column(
      children: [
        Text(
          points.toString(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 24.sp),
        ),
        Text(
          AppLocalKay.point.tr(),
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
