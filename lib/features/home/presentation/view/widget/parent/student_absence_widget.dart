import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class StudentAbsenceWidget extends StatelessWidget {
  const StudentAbsenceWidget({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.03)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.event_busy_outlined, size: 28, color: AppColor.errorColor(context)),
          Gap(16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalKay.absences.tr(), style: AppTextStyle.bodyMedium(context)),
              Text(
                "$count ${AppLocalKay.day.tr()}",
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColor.primaryColor(context)),
        ],
      ),
    );
  }
}
