import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BusLocationSectionWidget extends StatelessWidget {
  const BusLocationSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.blue, size: 24.w),
                  SizedBox(width: 8.w),
                  Text("الموقع الحالي", style: AppTextStyle.titleLarge(context)),
                ],
              ),
              Gap(12.h),
              Container(
                height: 150.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 40.w, color: Colors.grey),
                      Gap(8.h),
                      Text("خريطة موقع الحافلة", style: AppTextStyle.titleLarge(context)),
                    ],
                  ),
                ),
              ),
              Gap(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton("تحديث الموقع", Icons.refresh, context),
                  _buildActionButton("اتصال بالسائق", Icons.phone, context),
                  _buildActionButton("الإبلاغ عن مشكلة", Icons.report_problem, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20.w,
          backgroundColor: Colors.blue,
          child: Icon(icon, color: AppColor.whiteColor(context), size: 20.w),
        ),
        Gap(4.h),
        Text(text, style: AppTextStyle.bodyMedium(context), textAlign: TextAlign.center),
      ],
    );
  }
}
