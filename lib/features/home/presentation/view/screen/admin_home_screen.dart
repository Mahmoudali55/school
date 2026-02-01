import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/admin_header_widget.dart'
    show AdminHeader;
import 'package:my_template/features/home/presentation/view/widget/admin/alerts_and_activity_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/management_shortcuts_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/metrics_dashboard_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/mini_charts_widget.dart';

// ------------------- Main Screen -------------------
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final data = state.data;
            final adminData = data is AdminHomeModel ? data : null;

            if (state.isLoading && data == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (adminData != null) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminHeader(name: HiveMethods.getUserName(), role: adminData.userRole),
                    Gap(20.h),
                    MetricsDashboard(),
                    Gap(20.h),
                    MiniCharts(),
                    Gap(20.h),
                    AlertsAndActivity(),
                    Gap(20.h),
                    ManagementShortcuts(),
                    Gap(20.h),
                  ],
                ),
              );
            } else if (state.errorMessage != null && data == null) {
              return Center(child: Text(state.errorMessage!));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
