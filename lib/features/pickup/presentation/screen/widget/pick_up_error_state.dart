import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class PickUpErrorState extends StatelessWidget {
  const PickUpErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
            decoration: BoxDecoration(
              color: AppColor.errorColor(context).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: AppColor.errorColor(context).withValues(alpha: 0.8),
              size: 72.r,
            ),
          ),
          const Gap(24),
          Text(
            AppLocalKay.SERVER_CONNECTION_ERROR.tr(),
            style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.w900),
          ),
          const Gap(8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.hintColor(context)),
          ),
          const Gap(32),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, color: AppColor.whiteColor(context)),
            label: const Text("إعادة المحاولة", style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor(context),
              foregroundColor: AppColor.whiteColor(context),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              elevation: 4,
              shadowColor: AppColor.primaryColor(context).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
          ),
        ],
      ),
    );
  }
}
