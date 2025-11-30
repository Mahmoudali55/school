import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/on_boarding/data/model/on_boarding_model.dart';

class CustomPageViewWidget extends StatelessWidget {
  const CustomPageViewWidget({super.key, required this.page});

  final OnBoardingPageModel page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(80.h),
          Image.asset(page.image, height: 200.h),
          Gap(50.h),
          Text(
            page.title,
            style: AppTextStyle.titleLarge(
              context,
              color: AppColor.blackColor(context),
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
