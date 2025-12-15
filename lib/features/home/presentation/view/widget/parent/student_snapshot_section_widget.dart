import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/snapshot_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudentSnapshotWidget extends StatelessWidget {
  const StudentSnapshotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quick_snapshot.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 16.h),

        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFF0F4FF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SnapshotItem(
                title: AppLocalKay.checkin.tr(),
                child: CircularPercentIndicator(
                  radius: 35.w,
                  lineWidth: 6.w,
                  percent: 0.98,
                  center: Text(
                    "98%",
                    style: AppTextStyle.bodySmall(
                      context,
                      color: const Color(0xFF10B981),
                    ).copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                  ),
                  progressColor: const Color(0xFF10B981),
                  backgroundColor: const Color(0xFFD1FAE5),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),

              SnapshotItem(
                title: AppLocalKay.grades.tr(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "العلوم",
                        style: AppTextStyle.bodySmall(
                          context,
                          color: const Color(0xFF2E5BFF),
                        ).copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "85/100",
                        style: AppTextStyle.bodyMedium(
                          context,
                          color: const Color(0xFF1F2937),
                        ).copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),

              SnapshotItem(
                title: AppLocalKay.behaviors.tr(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF2E5BFF), Color(0xFF7C3AED)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "ممتاز",
                    style: AppTextStyle.bodySmall(
                      context,
                      color: Colors.white,
                    ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
