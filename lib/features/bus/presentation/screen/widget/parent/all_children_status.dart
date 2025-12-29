import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AllChildrenStatus extends StatelessWidget {
  final List<Map<String, dynamic>> childrenBusData;

  const AllChildrenStatus({super.key, required this.childrenBusData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalKay.all_children.tr(),
                style: AppTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${childrenBusData.length} ${AppLocalKay.children.tr()}",
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: AppColor.primaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250.h),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: childrenBusData.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) =>
                  _buildChildStatusItem(context, childrenBusData[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildStatusItem(
    BuildContext context,
    Map<String, dynamic> childData,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: childData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: childData['busColor'],
              size: 18.w,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  childData['childName'],
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${childData['school']} • ${childData['estimatedTime']}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: childData['onBoard']
                      ? AppColor.secondAppColor(context).withOpacity(0.1)
                      : AppColor.accentColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  childData['onBoard']
                      ? AppLocalKay.in_bus.tr()
                      : AppLocalKay.waiting.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 9.sp,
                    color: childData['onBoard']
                        ? AppColor.secondAppColor(context)
                        : AppColor.accentColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                childData['attendance'],
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontSize: 10.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
