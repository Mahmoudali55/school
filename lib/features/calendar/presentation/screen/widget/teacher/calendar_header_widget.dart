import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class CalendarHeaderWidget extends StatelessWidget {
  const CalendarHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, color: AppColor.accentColor(context), size: 20.w),
          SizedBox(width: 8.w),
          Text(
            AppLocalKay.calendarClass.tr(),
            style: AppTextStyle.titleMedium(context).copyWith(color: AppColor.accentColor(context)),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.notifications_rounded, size: 20.w, color: const Color(0xFF6B7280)),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.accentColor(context)),
            child: Center(
              child: Icon(Icons.school, color: AppColor.whiteColor(context), size: 16.w),
            ),
          ),
        ],
      ),
    );
  }
}
