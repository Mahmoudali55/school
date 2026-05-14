import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';

class UniformCard extends StatelessWidget {
  const UniformCard({required this.item, required this.onEdit});

  final UniformItem item;
  final VoidCallback onEdit;

  static const _sizeColors = {
    'S': Color(0xFF6C63FF),
    'M': Color(0xFF2196F3),
    'L': Color(0xFF4CAF50),
    'XL': Color(0xFFFF9800),
    'XXL': Color(0xFFF44336),
    'XXXL': Color(0xFF9C27B0),
  };

  Color get _sizeColor =>
      _sizeColors[item.size] ?? const Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: _sizeColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: _sizeColor.withValues(alpha: 0.2),
                  child: Text(
                    item.studentName.isNotEmpty
                        ? item.studentName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: _sizeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    item.studentName,
                    style: AppTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Size badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _sizeColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    item.size,
                    style: TextStyle(
                      color:  AppColor.whiteColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Gap(8.w),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor(context).withValues(
                        alpha: 0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 16.w,
                      color: AppColor.primaryColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Measurements row
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: _MeasurementChip(
                    icon: Icons.height_rounded,
                    label: AppLocalKay.height.tr(),
                    value: '${item.height} cm',
                    color: const Color(0xFF2196F3),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: _MeasurementChip(
                    icon: Icons.monitor_weight_outlined,
                    label: AppLocalKay.weight.tr(),
                    value: '${item.weight} kg',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),

          if (item.notes.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes_rounded,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    Gap(6.w),
                    Expanded(
                      child: Text(
                        item.notes,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
class _MeasurementChip extends StatelessWidget {
  const _MeasurementChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          Gap(8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

