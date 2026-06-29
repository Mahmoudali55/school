import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/admin_header_widget.dart'
    show AdminHeader;
import 'package:my_template/features/home/presentation/view/widget/admin/alerts_and_activity_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/management_shortcuts_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/metrics_dashboard_widget.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: Container(
        
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final data = state.data;
              final adminData = data is AdminHomeModel ? data : null;

              if (state.isLoading && data == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (adminData != null) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape = constraints.maxWidth > constraints.maxHeight;

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminHeader(name: HiveMethods.getUserName2()),
                          Gap(24.h),
                          if (isLandscape)
                           _buildLandscapeLayout(context, adminData)
                          else
                            _buildPortraitLayout(context, adminData),
                        ],
                      ),
                    );
                  },
                );
              } else if (state.errorMessage != null && data == null) {
                return Center(child: Text(state.errorMessage!));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, AdminHomeModel adminData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricsDashboard(metricsData: adminData.metrics),
        // Gap(24.h),
        // if (adminData.miniCharts != null && adminData.miniCharts!.isNotEmpty) ...[
        //   MiniCharts(chartsData: adminData.miniCharts!),
        //   Gap(24.h),
        // ],
        AlertsAndActivity(),
         Gap(24.h),
        ManagementShortcuts(),
        Gap(24.h),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, AdminHomeModel adminData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              MetricsDashboard(metricsData: adminData.metrics),
            //   Gap(24.h),
            //   if (adminData.miniCharts != null && adminData.miniCharts!.isNotEmpty) ...[
            //     MiniCharts(chartsData: adminData.miniCharts!),
           
            //   ],
                 Gap(24.h),
               AlertsAndActivity(),
            ],
          ),
        ),
        Gap(24.w),
        Expanded(
          flex: 2,
          child: ManagementShortcuts(),
        ),
      ],
    );
  }
}
