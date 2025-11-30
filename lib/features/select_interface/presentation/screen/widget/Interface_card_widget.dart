import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class InterfaceCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const InterfaceCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColor.primaryColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      child: Material(
        borderRadius: BorderRadius.circular(18),
        color: isSelected ? primary.withOpacity(.85) : primary.withOpacity(.25),
        elevation: isSelected ? 3 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          splashColor: primary.withOpacity(.2),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 22.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.whiteColor(context).withOpacity(.2),
                  ),
                  child: Icon(icon, size: 42.sp, color: AppColor.whiteColor(context)),
                ),
                Gap(12.h),
                Text(
                  title,
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: AppColor.whiteColor(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
