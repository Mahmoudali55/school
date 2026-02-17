import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';

class ShortcutCard extends StatelessWidget {
  final ManagementShortcut shortcut;
  const ShortcutCard({super.key, required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: AppColor.whiteColor(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: shortcut.color.withValues(alpha: (0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(shortcut.icon, color: shortcut.color, size: 20.w),
          ),
          Gap(6.h),
          Text(
            shortcut.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            shortcut.description,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodySmall(
              context,
              color: Colors.grey[600],
            ).copyWith(fontSize: 8.sp),
          ),
        ],
      ),
    );
  }
}
