import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class MonthlyStatsWidget extends StatelessWidget {
  final DateTime selectedDate;

  const MonthlyStatsWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final stats = state.getMonthlyStats(selectedDate);

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.stats.tr(),
                style: AppTextStyle.titleMedium(context, color: const Color(0xFF1F2937)),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    AppLocalKay.classe.tr(),
                    stats['classes'] ?? 0,
                    AppColor.accentColor(context),
                    Icons.school_rounded,
                    context,
                  ),
                  _buildStatItem(
                    AppLocalKay.exams.tr(),
                    stats['exams'] ?? 0,
                    AppColor.errorColor(context),
                    Icons.assignment_rounded,
                    context,
                  ),
                  _buildStatItem(
                    AppLocalKay.meetings.tr(),
                    stats['meetings'] ?? 0,
                    AppColor.secondAppColor(context),
                    Icons.groups_rounded,
                    context,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, int count, Color color, IconData icon, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 18.w, color: color),
        ),
        SizedBox(height: 6.h),
        Text('$count', style: AppTextStyle.titleMedium(context, color: color)),
        SizedBox(height: 2.h),
        Text(title, style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context))),
      ],
    );
  }
}
