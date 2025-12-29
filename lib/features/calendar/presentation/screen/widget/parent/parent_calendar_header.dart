import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ParentCalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final String Function(DateTime) getFormattedDate;

  const ParentCalendarHeader({
    super.key,
    required this.selectedDate,
    required this.getFormattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.follow_up.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                getFormattedDate(selectedDate),
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.family_restroom_rounded,
              color: const Color(0xFF2196F3),
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
