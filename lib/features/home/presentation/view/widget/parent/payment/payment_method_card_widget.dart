import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class PaymentMethodCardWidget extends StatelessWidget {
  const PaymentMethodCardWidget({super.key, this.image, this.icon, required this.label, required this.isSelected, required this.onTap});
    final String? image;
    final IconData? icon;
    final String label;
    final bool isSelected;
    final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor(context) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? AppColor.primaryColor(context).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 8 : 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (image != null) Image.asset(image ?? '', width: 40.w, height: 40.h, fit: BoxFit.contain),
                if (icon != null) Icon(icon, size: 40.sp, color: isSelected ? AppColor.primaryColor(context) : Colors.grey.shade600),
                if (isSelected)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColor.primaryColor(context),
                      size: 16.sp,
                    ),
                  ),
              ],
            ),
            Gap(4.h),
            Text(
              label,
              style: AppTextStyle.labelSmall(context).copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColor.primaryColor(context) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}