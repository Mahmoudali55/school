import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';

class AdminQuickOverview extends StatelessWidget {
  const AdminQuickOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem(
                context,
                state.buses.length.toString(),
                AppLocalKay.buses.tr(),
                Icons.directions_bus_rounded,
                const Color(0xFF10B981),
              ),
              _buildOverviewItem(
                context,
                state.overviewStats['totalStudents'].toString(),
                AppLocalKay.stats_students.tr(),
                Icons.people_rounded,
                AppColor.primaryColor(context),
              ),
              _buildOverviewItem(
                context,
                state.overviewStats['attendanceRate'].toString(),
                AppLocalKay.checkin.tr(),
                Icons.percent_rounded,
                AppColor.accentColor(context),
              ),
              _buildOverviewItem(
                context,
                "3/4",
                AppLocalKay.user_management_active.tr(),
                Icons.check_circle_rounded,
                const Color(0xFFEC4899),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(fontSize: 11.sp, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
