import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class RouteProgress extends StatelessWidget {
  final List<Map<String, dynamic>> stops;

  const RouteProgress({super.key, required this.stops});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.routes.tr(),
            style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          ...stops.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> stop = entry.value;
            bool isLast = index == stops.length - 1;
            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: stop['current']
                              ? AppColor.secondAppColor(context)
                              : stop['passed']
                              ? AppColor.secondAppColor(context).withOpacity(0.5)
                              : AppColor.whiteColor(context),
                          shape: BoxShape.circle,
                        ),
                        child: stop['current']
                            ? Icon(
                                Icons.directions_bus_rounded,
                                size: 12.w,
                                color: AppColor.whiteColor(context),
                              )
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2.w,
                          height: 40.h,
                          color: stop['passed']
                              ? AppColor.secondAppColor(context)
                              : AppColor.whiteColor(context),
                        ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stop['name'], style: AppTextStyle.bodyMedium(context)),
                        Text(
                          stop['time'],
                          style: AppTextStyle.bodyMedium(
                            context,
                            color: AppColor.greyColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
