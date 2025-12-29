import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BusStatusCardWidget extends StatelessWidget {
  const BusStatusCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.directions_bus_rounded, color: Colors.green, size: 32.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الحافلة قادمة",
                        style: AppTextStyle.titleLarge(context).copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "متوقع الوصول خلال ٥ دقائق",
                        style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ],
        ),
      ),
    );
  }
}
