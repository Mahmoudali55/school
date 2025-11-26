import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class NotificationSectionWidget extends StatelessWidget {
  const NotificationSectionWidget({super.key, required this.title, required this.notifications});
  final String title;
  final List<Widget> notifications;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(title, style: AppTextStyle.titleLarge(context)),
        ),
        SizedBox(height: 12.h),
        Column(children: notifications),
      ],
    );
  }
}
