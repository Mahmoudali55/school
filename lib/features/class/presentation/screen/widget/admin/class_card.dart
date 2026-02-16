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

    // Determine status color based on fill percentage
    Color statusColor;
    String statusText;

    if (fillPercentage >= 0.9) {
      statusColor = Colors.redAccent;
      statusText = AppLocalKay.filter_full.tr();
    } else if (fillPercentage >= 0.7) {
      statusColor = Colors.orangeAccent;
      statusText = AppLocalKay.class_status_almost_full.tr();
    } else {
      statusColor = const Color(0xFF00C853); // Vibrant Green
      statusText = AppLocalKay.filter_available.tr();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.class_outlined,
                          color: AppColor.primaryColor(context),
                          size: 20.sp,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Text(
                          classModel.classNameAr,
                          style: AppTextStyle.titleMedium(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3748),
                            fontSize: 16.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: (0.15)),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withValues(alpha: (0.3))),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8.sp, color: statusColor),
                      Gap(4.w),
                      Text(
                        statusText,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 11.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Info Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        Icons.person_outline,
                        AppLocalKay.teacher.tr(),
                        classModel.teacherName ?? AppLocalKay.unknown.tr(),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        Icons.meeting_room_outlined,
                        AppLocalKay.label_room.tr(),
                        classModel.floorName ?? AppLocalKay.unknown.tr(),
                      ),
                    ),
                  ],
                ),

                Gap(20.h),

                // Capacity Progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalKay.label_capacity.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$totalStudents',
                                style: AppTextStyle.bodyMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                              TextSpan(
                                text: '/${classModel.classCapacity}',
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(8.h),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 8.h,
                      percent: fillPercentage > 1.0 ? 1.0 : fillPercentage,
                      backgroundColor: Colors.grey[100],
                      progressColor: statusColor,
                      barRadius: Radius.circular(4.r),
                      animation: true,
                      animationDuration: 1000,
                    ),
                  ],
                ),

                Gap(20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[400]),
        Gap(8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: Colors.grey[500], fontSize: 10.sp),
              ),
              Gap(2.h),
              Text(
                value,
                style: AppTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A5568),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
