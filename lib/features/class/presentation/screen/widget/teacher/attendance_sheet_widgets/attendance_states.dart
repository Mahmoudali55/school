import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AttendanceLoadingState extends StatelessWidget {
  const AttendanceLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.primaryColor(context), strokeWidth: 3),
          Gap(16.h),
          Text(
            AppLocalKay.loading_data.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}

class AttendanceEmptyState extends StatelessWidget {
  const AttendanceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30.r),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 80.sp,
                color: Colors.green.withValues(alpha: 0.5),
              ),
            ),
            Gap(24.h),
            Text(
              AppLocalKay.no_absence_today.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: AppColor.greyColor(context)),
            ),
            Gap(8.h),
            Text(
              AppLocalKay.happy_day.tr(),
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.greyColor(context).withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceErrorState extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;

  const AttendanceErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60.sp, color: AppColor.errorColor(context)),
            Gap(16.h),
            Text(error ?? "", textAlign: TextAlign.center, style: AppTextStyle.bodyMedium(context)),
            Gap(24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text(AppLocalKay.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
