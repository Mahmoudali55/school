import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class UniformStatusWidget extends StatelessWidget {
  final String? studentId;
  const UniformStatusWidget({super.key, this.studentId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.school_uniform.tr(),
          style: AppTextStyle.headlineMedium(
            context,
            color: const Color(0xFF1F2937),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            color: AppColor.whiteColor(context),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.checkroom,
                                color: const Color(0xFF2E5BFF),
                                size: 20.w,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalKay.student_sizes.tr(),
                                    style: AppTextStyle.bodySmall(
                                      context,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    AppLocalKay.input_sizes.tr(),
                                    style: AppTextStyle.headlineMedium(
                                      context,
                                      color: const Color(0xFF1F2937),
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.uniformParentScreen,
                        arguments: studentId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5BFF),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalKay.request_uniform.tr(),
                      style: AppTextStyle.labelMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
