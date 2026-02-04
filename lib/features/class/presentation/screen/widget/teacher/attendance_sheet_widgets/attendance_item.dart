import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AttendanceItem extends StatelessWidget {
  final int index;
  final dynamic item; // Typed 'dynamic' in original code, ideally should be typed if model is known
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AttendanceItem({
    super.key,
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAbsent = item.absentType == 0;

    return FadeInUp(
      duration: Duration(milliseconds: 400 + (index * 100)),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColor.scaffoldColor(context),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor(context).withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 6.w,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAbsent
                          ? [
                              AppColor.errorColor(context),
                              AppColor.errorColor(context).withValues(alpha: 0.6),
                            ]
                          : [
                              AppColor.infoColor(context),
                              AppColor.infoColor(context).withValues(alpha: 0.6),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color:
                                (isAbsent
                                        ? AppColor.errorColor(context)
                                        : AppColor.infoColor(context))
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Icon(
                            isAbsent ? Icons.person_off_rounded : Icons.beach_access_rounded,
                            color: isAbsent
                                ? AppColor.errorColor(context)
                                : AppColor.infoColor(context),
                            size: 24.sp,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.studentFullName,
                                style: AppTextStyle.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              Gap(4.h),
                              Text(
                                item.notes.isEmpty
                                    ? (isAbsent
                                          ? AppLocalKay.unexcused_absence.tr()
                                          : AppLocalKay.excused_absence.tr())
                                    : item.notes,
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(color: AppColor.greyColor(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color:
                                (isAbsent
                                        ? AppColor.errorColor(context)
                                        : AppColor.infoColor(context))
                                    .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color:
                                  (isAbsent
                                          ? AppColor.errorColor(context)
                                          : AppColor.infoColor(context))
                                      .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            isAbsent ? AppLocalKay.absent.tr() : AppLocalKay.excused.tr(),
                            style: TextStyle(
                              color: isAbsent
                                  ? AppColor.errorColor(context)
                                  : AppColor.infoColor(context),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(12.h),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColor.greyColor(context).withValues(alpha: 0.1),
                    ),
                    Gap(12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.edit_rounded,
                          label: AppLocalKay.btn_edit.tr(),
                          color: AppColor.primaryColor(context),
                          onTap: onEdit,
                        ),
                        Gap(12.w),
                        _buildActionButton(
                          context,
                          icon: Icons.delete_outline_rounded,
                          label: AppLocalKay.delete.tr(),
                          color: AppColor.errorColor(context),
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16.sp),
            Gap(4.w),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
