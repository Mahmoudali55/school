import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AdminHeader extends StatelessWidget {
  final String name;

  const AdminHeader({super.key, required this.name});

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
                AppLocalKay.adminPanel.tr(),
                style: AppTextStyle.headlineSmall(
                  context,
                  color: AppColor.primaryColor(context),
                ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Gap(4.h),
              Text(
                name,
                style: AppTextStyle.headlineSmall(
                  context,
                  color: const Color(0xFF1F2937),
                ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
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
                color: AppColor.blackColor(context).withOpacity(0.1),
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
