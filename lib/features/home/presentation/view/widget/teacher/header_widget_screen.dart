import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class HeaderWidget extends StatelessWidget {
  final String teacherName;
  final List<String> subjects;

  const HeaderWidget({super.key, required this.teacherName, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.welcome.tr(),
                  style: AppTextStyle.bodyLarge(context).copyWith(color: const Color(0xFF1F2937)),
                ),
                Text(
                  teacherName,
                  style: AppTextStyle.headlineSmall(
                    context,
                  ).copyWith(color: const Color(0xFF1F2937)),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.school, color: AppColor.primaryColor(context), size: 28.w),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: subjects.map((subject) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.primaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.primaryColor(context).withOpacity(0.3)),
              ),
              child: Text(
                subject,
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.primaryColor(context)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
