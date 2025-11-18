import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/on_boarding/presentation/view/cubit/on_boarding_state.dart';

class CustomDotsListIndexWidget extends StatelessWidget {
  final OnBoardingState state;

  const CustomDotsListIndexWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        state.onboardingData.length,
        (index) => Container(
          margin:  EdgeInsets.all(4.h),
          width: state.currentPage == index ? 20 : 8,
          height: 8.h,
          decoration: BoxDecoration(
            color: state.currentPage == index
                ? AppColor.primaryColor(context)
                : const Color(0xFFBDBDBD),
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
      ),
    );
  }
}
