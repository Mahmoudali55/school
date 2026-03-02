import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';

class ScheduleItemWidget extends StatelessWidget {
  final ScheduleItem item;
  const ScheduleItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
        color: item.isCurrent ? const Color(0xFFEFF6FF) : AppColor.whiteColor(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: item.isCurrent ? AppColor.primaryColor(context) : AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.time,
              style: AppTextStyle.bodySmall(
                context,
                color: item.isCurrent ? AppColor.whiteColor(context) : AppColor.greyColor(context),
              ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subject,
                  style: AppTextStyle.titleMedium(
                    context,
                    color: const Color(0xFF1F2937),
                  ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Gap(4.h),
                Row(
                  children: [
                    Icon(Icons.class_, size: 14.w, color: AppColor.greyColor(context)),
                    Gap(4.w),
                    Flexible(
                      child: Text(
                        item.classroom,
                        style: AppTextStyle.bodySmall(
                          context,
                          color: AppColor.greyColor(context),
                        ).copyWith(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(12.w),
                    Icon(Icons.room, size: 14.w, color: AppColor.greyColor(context)),
                    Gap(4.w),
                    Flexible(
                      child: Text(
                        item.room,
                        style: AppTextStyle.bodySmall(
                          context,
                          color: AppColor.greyColor(context),
                        ).copyWith(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (item.isCurrent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColor.secondAppColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalKay.now.tr(),
                style: AppTextStyle.bodySmall(
                  context,
                  color: AppColor.whiteColor(context),
                ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
