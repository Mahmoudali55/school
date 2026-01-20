import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        AppLocalKay.digital_library.tr(),
        Icons.menu_book,
        AppColor.primaryColor(context),
        RoutesName.digitalLibraryScreen,
      ),
      (
        AppLocalKay.todostitle.tr(),
        Icons.assignment,
        AppColor.accentColor(context),
        RoutesName.assignmentsScreen,
      ),
      (
        AppLocalKay.schedules.tr(),
        Icons.schedule,
        AppColor.secondAppColor(context),
        RoutesName.scheduleScreen,
      ),
      (AppLocalKay.grades.tr(), Icons.bar_chart, Colors.purple, RoutesName.gradesScreen),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quick_actions.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(actions.length, (i) {
            final item = actions[i];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    NavigatorMethods.pushNamed(context, item.$4);
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: item.$3.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(item.$2, color: item.$3, size: 28.w),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.$1,
                  style: AppTextStyle.labelSmall(
                    context,
                    color: AppColor.textColor(context),
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
