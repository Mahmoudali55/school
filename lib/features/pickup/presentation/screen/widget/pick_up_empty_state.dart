import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class PickUpEmptyState extends StatelessWidget {
  const PickUpEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 160.r,
                width: 160.r,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  size: 64.r,
                  color: AppColor.primaryColor(context).withValues(alpha: 0.2),
                ),
              ),
              const Gap(24),
              Text(
                AppLocalKay.NO_PENDING_REQUESTS.tr(),
                style: AppTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                  color: AppColor.textColor(context),
                ),
              ),
              const Gap(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Text(
                  AppLocalKay.NO_PENDING_REQUESTS.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.hintColor(context), height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
