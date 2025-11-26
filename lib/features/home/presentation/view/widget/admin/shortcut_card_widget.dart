import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/class/data/model/alert_model.dart';

class ShortcutCard extends StatelessWidget {
  final ManagementShortcut shortcut;
  const ShortcutCard({super.key, required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: shortcut.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(shortcut.icon, color: shortcut.color, size: 20.w),
          ),
          SizedBox(height: 6.h),
          Text(
            shortcut.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            shortcut.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
