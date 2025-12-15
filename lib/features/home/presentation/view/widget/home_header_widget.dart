import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
    required this.studentName,
    required this.classInfo,
    this.onNotificationTap,
  });

  final String studentName;
  final String classInfo;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            NavigatorMethods.pushNamed(context, RoutesName.profileScreen);
          },
          child: CircleAvatar(
            radius: 26.w,
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.person, color: Colors.blue, size: 28.w),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "مرحباً، $studentName",
                style: AppTextStyle.headlineSmall(context).copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                classInfo,
                style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
              ),
            ],
          ),
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
          child: Icon(Icons.school, color: AppColor.secondAppColor(context), size: 28.w),
        ),
      ],
    );
  }
}
