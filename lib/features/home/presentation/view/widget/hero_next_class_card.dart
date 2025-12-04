import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class HeroNextClassCard extends StatelessWidget {
  const HeroNextClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondAppColor(context), AppColor.primaryColor(context)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: AppColor.whiteColor(context), size: 26.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.join_class.tr(),
                style: AppTextStyle.bodyLarge(
                  context,
                  color: AppColor.whiteColor(context),
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Text(
            "الرياضيات",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor(context),
            ),
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.access_time, color: AppColor.whiteColor(context), size: 16.w),
              SizedBox(width: 6.w),
              Text(
                "١٠:٠٠ - ١٠:٤٥ صباحاً",
                style: TextStyle(color: AppColor.whiteColor(context), fontSize: 14.sp),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Icon(Icons.person, color: AppColor.whiteColor(context), size: 16.w),
              SizedBox(width: 6.w),
              Text(
                "أ. أحمد محمد",
                style: TextStyle(color: AppColor.whiteColor(context), fontSize: 14.sp),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.video_call, size: 20.w),
            label: Text(
              "انضم إلى الحصة الافتراضية",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primaryColor(context),
              backgroundColor: AppColor.whiteColor(context),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
