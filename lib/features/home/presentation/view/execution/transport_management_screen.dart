import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TransportManagementScreen extends StatelessWidget {
  const TransportManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.transport_desc.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.busDataStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.busDataStatus.isFailure) {
            return Center(child: Text(state.busDataStatus.error ?? "Error"));
          } else if (state.busDataStatus.isSuccess) {
            final buses = state.busDataStatus.data ?? [];
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Buses Overview
                  _buildBusesOverview(context, buses),
                  Gap(20.h),
                  // Buses List
                  Expanded(child: _buildBusesList(buses)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBusesOverview(BuildContext context, List<BusDataModel> buses) {
    final activeCount = buses.where((b) => b.driverNameAr != null && b.lineNameAr != null).length;
    final maintenanceCount = buses.length - activeCount;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade400]),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            AppLocalKay.total_buses.tr(),
            buses.length.toString(),
            Icons.directions_bus,
          ),
          _buildStatItem(AppLocalKay.active.tr(), activeCount.toString(), Icons.check_circle),
          _buildStatItem(AppLocalKay.maintenance.tr(), maintenanceCount.toString(), Icons.build),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        Gap(8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildBusesList(List<BusDataModel> buses) {
    if (buses.isEmpty) {
      return Center(child: Text(AppLocalKay.no_buses_found.tr()));
    }
    return ListView.builder(
      itemCount: buses.length,
      itemBuilder: (context, index) => _buildBusCard(buses[index], context),
    );
  }

  Widget _buildBusCard(BusDataModel bus, BuildContext context) {
    final bool isActive = bus.driverNameAr != null && bus.lineNameAr != null;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bus.lineNameAr ?? AppLocalKay.no_line.tr(),
                    style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    isActive ? AppLocalKay.active.tr() : AppLocalKay.maintenance.tr(),
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Gap(20.h),

            _buildBusInfoRow(
              Icons.confirmation_number,
              "${AppLocalKay.bus_code.tr()}: ${bus.busCode ?? "-"}",
            ),
            Gap(10.h),
            _buildBusInfoRow(
              Icons.credit_card,
              "${AppLocalKay.plate_no.tr()}: ${bus.plateNo ?? "-"}",
            ),
            Gap(10.h),
            _buildBusInfoRow(
              Icons.person,
              "${AppLocalKay.driver.tr()}: ${bus.driverNameAr ?? "-"}",
            ),
            Gap(10.h),
            _buildBusInfoRow(
              Icons.supervisor_account,
              "${AppLocalKay.supervisor.tr()}: ${bus.supervisorNameAr1 ?? "-"}",
            ),
            Gap(10.h),
            _buildBusInfoRow(
              Icons.event_seat,
              "${AppLocalKay.bus_seats.tr()}: ${bus.busSets ?? 0}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        Gap(10),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
