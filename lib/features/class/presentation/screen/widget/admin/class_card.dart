import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/class_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ClassCard extends StatelessWidget {
  final GetClassModel classModel;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onManageStudents;

  const ClassCard({
    super.key,
    required this.classModel,
    required this.onViewDetails,
    required this.onEdit,
    required this.onManageStudents,
  });

  @override
  Widget build(BuildContext context) {
    int totalStudents = (classModel.newStudent ?? 0) + (classModel.oldStudent ?? 0);
    double fillPercentage = classModel.classCapacity > 0
        ? (totalStudents / classModel.classCapacity)
        : 0.0;

    Color statusColor;
    String statusText;

    if (fillPercentage >= 0.9) {
      statusColor = AppColor.errorColor(context);
      statusText = AppLocalKay.filter_full.tr();
    } else if (fillPercentage >= 0.7) {
      statusColor = AppColor.warningColor(context);
      statusText = AppLocalKay.class_status_almost_full.tr();
    } else {
      statusColor = AppColor.successColor(context);
      statusText = AppLocalKay.filter_available.tr();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.door_sliding_outlined,
                  color: AppColor.primaryColor(context),
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classModel.classNameAr,
                      style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${classModel.floorName ?? 'الدور الأرضي'}",
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(color: AppColor.greyColor(context)),
                    ),
                  ],
                ),
              ),
              _buildRefinedBadge(context, statusText, statusColor),
            ],
          ),
          Gap(20.h),
          // Info Section
          Row(
            children: [
              _buildRefinedInfoItem(
                context,
                Icons.person_outline_rounded,
                AppLocalKay.teacher.tr(),
                classModel.teacherName ?? "غير محدد",
              ),
            ],
          ),
          Gap(16.h),
          // Capacity Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "إشغال الفصل",
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600, fontSize: 10.sp),
                  ),
                  Text(
                    "$totalStudents / ${classModel.classCapacity}",
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: AppColor.textColor(context)),
                  ),
                ],
              ),
              Gap(8.h),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 6.h,
                percent: fillPercentage > 1.0 ? 1.0 : fillPercentage,
                backgroundColor: AppColor.grey100Color(context),
                progressColor: statusColor,
                barRadius: Radius.circular(3.r),
                animation: true,
                animationDuration: 800,
              ),
            ],
          ),
          Gap(20.h),
          // Divider
          Divider(color: AppColor.dividerColor(context), height: 1),
          Gap(12.h),
          // Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(
                context,
                Icons.edit_note_rounded,
                AppColor.greyColor(context),
                onEdit,
              ),
              Gap(8.w),
              _buildTextButton(
                context,
                "الطلاب",
                Icons.group_outlined,
                AppColor.successColor(context),
                onManageStudents,
              ),
              Gap(8.w),
              _buildTextButton(
                context,
                "التفاصيل",
                Icons.arrow_forward_rounded,
                AppColor.primaryColor(context),
                onViewDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefinedBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 9.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRefinedInfoItem(BuildContext context, IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColor.grey50Color(context),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: AppColor.iconColor(context)),
            Gap(8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 8.sp, color: AppColor.greyColor(context)),
                ),
                Text(
                  value,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, height: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold),
            ),
            Gap(4.w),
            Icon(icon, size: 14.sp, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, color: color, size: 20.sp),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
