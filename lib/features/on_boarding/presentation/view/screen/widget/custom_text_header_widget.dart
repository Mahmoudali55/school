import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class CustomTextHeaderWidget extends StatelessWidget {
  const CustomTextHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => NavigatorMethods.pushNamedAndRemoveUntil(context, RoutesName.loginScreen),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
          child: Text(AppLocalKay.skip.tr(), style: AppTextStyle.text16MSecond(context)),
        ),
      ),
    );
  }
}
