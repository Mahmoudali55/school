import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class AdminHeader extends StatelessWidget {
  final String name;
  final String role;
  const AdminHeader({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "لوحة تحكم الإدارة",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "$name - $role",
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.admin_panel_settings, color: const Color(0xFF9C27B0), size: 24.w),
        ),
      ],
    );
  }
}
