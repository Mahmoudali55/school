import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.route.tr(),
      child: Column(
        children: [
          Container(
            height: 280.h,
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.whiteColor(context).withOpacity(0.06),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(Icons.map_rounded, size: 110.sp, color: Colors.grey.shade500),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Route info section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange),
                    SizedBox(width: 8.w),
                    Text(
                      'نقطة الانطلاق: المدرسة',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                Row(
                  children: [
                    Icon(Icons.flag_circle_rounded, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Text(
                      'الوجهة: المنزل',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.green),
                    SizedBox(width: 8.w),
                    Text(
                      'الوقت المتوقع: 12 دقيقة',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          CustomButton(
            text: AppLocalKay.update_location.tr(),
            color: AppColor.accentColor(context),
            radius: 12.r,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
