import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class WelcomeParentWidget extends StatelessWidget {
  const WelcomeParentWidget({super.key, required this.parentName});

  final String parentName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalKay.welcome.tr(),
              style: AppTextStyle.bodyLarge(context, color: const Color(0xFF6B7280)),
            ),
            Text(
              parentName,
              style: AppTextStyle.headlineSmall(
                context,
                color: const Color(0xFF1F2937),
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            NavigatorMethods.pushNamed(
              context,
              RoutesName.parentProfileScreen,
              arguments: int.tryParse(HiveMethods.getUserCode()) ?? 0,
            );
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withAlpha((0.1 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.family_restroom, color: AppColor.primaryColor(context), size: 28.w),
          ),
        ),
      ],
    );
  }
}
