import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/global_icon/graduate.png',
      height: 150.h,
      width: 150.w,
      color: AppColor.primaryColor(context),
    );
  }
}
