import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class CardBack extends StatelessWidget {
  final String cvv;

  const CardBack({required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 195.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context).withValues(alpha: (0.85)),
            AppColor.primaryColor(context),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor(context).withValues(alpha: (0.35)),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(28.h),

          // Magnetic stripe
          Container(
            height: 44.h,
            color: Colors.black87,
          ),

          Gap(20.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'CVV',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 9.sp,
                    letterSpacing: 1.5,
                  ),
                ),
                Gap(6.h),

                // CVV strip
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor(context),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          cvv.isEmpty
                              ? '•••'
                              : '•' * cvv.length,
                          key: ValueKey(cvv.length),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: EdgeInsets.only(right: 22.w, bottom: 14.h),
            child: Text(
              'Authorized Signature',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 8.sp,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}