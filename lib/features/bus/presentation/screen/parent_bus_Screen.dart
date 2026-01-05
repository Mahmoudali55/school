import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/all_children_status.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/bus_details.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/children_selector.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/main_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/parent_emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/quick_overview.dart';
import 'package:my_template/features/bus/presentation/screen/widget/parent/safety_alerts.dart';

class ParentBusTrackingScreen extends StatefulWidget {
  const ParentBusTrackingScreen({super.key});

  @override
  State<ParentBusTrackingScreen> createState() => _ParentBusTrackingScreenState();
}

class _ParentBusTrackingScreenState extends State<ParentBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _busAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final selectedBusData = state.selectedClass;
        if (selectedBusData == null) {
          return const Scaffold(body: Center(child: Text("لا توجد بيانات متاحة")));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFD),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: Text(
                        AppLocalKay.bus_title.tr(),
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Children Selector
                SliverToBoxAdapter(
                  child: ChildrenSelector(
                    children: state.parentChildrenBuses.map((e) => e.childName ?? "").toList(),
                    selectedChild: selectedBusData.childName ?? "",
                    childrenBusData: state.parentChildrenBuses,
                    onSelected: (childName) {
                      final selected = state.parentChildrenBuses.firstWhere(
                        (e) => e.childName == childName,
                      );
                      context.read<BusCubit>().selectClass(selected.id);
                    },
                  ),
                ),

                // Quick Overview
                SliverToBoxAdapter(
                  child: QuickOverview(
                    childrenCount: state.parentChildrenBuses.length,
                    inBusCount: state.parentChildrenBuses
                        .where((c) => c.status == 'في الطريق')
                        .length,
                    nearestArrival: state.overviewStats['closestArrival'] ?? "---",
                    safetyStatus: "٣/٣",
                  ),
                ),

                // Main Tracking Card
                SliverToBoxAdapter(
                  child: MainTrackingCard(
                    selectedBusData: selectedBusData,
                    busAnimation: _busAnimation,
                    onCallDriver: () => _callDriver(selectedBusData),
                    onShareLocation: () => _shareLocation(selectedBusData),
                    onSetArrivalAlert: () => _setArrivalAlert(selectedBusData),
                  ),
                ),

                // All Children Status
                SliverToBoxAdapter(
                  child: AllChildrenStatus(childrenBusData: state.parentChildrenBuses),
                ),

                // Bus Details
                SliverToBoxAdapter(child: BusDetails(selectedBusData: selectedBusData)),

                // Safety & Alerts
                SliverToBoxAdapter(
                  child: SafetyAlerts(
                    onFeatureTap: (feature) => _handleSafetyFeature(feature, selectedBusData),
                  ),
                ),
              ],
            ),
          ),

          // Emergency Button
          floatingActionButton: ParentEmergencyButton(
            onPressed: () => _showEmergencyDialog(selectedBusData),
          ),
        );
      },
    );
  }

  void _callDriver(BusClass selectedBusData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.ConnectDriverHint.tr()}${selectedBusData.driverName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalKay.Connect.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _shareLocation(BusClass selectedBusData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalKay.share_location.tr()} ${selectedBusData.childName}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _setArrivalAlert(BusClass selectedBusData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.arrival_alert.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.alert_message.tr()}${selectedBusData.childName} بـ 10 دقائق'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.confirm.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _handleSafetyFeature(String feature, BusClass selectedBusData) {
    switch (feature) {
      case AppLocalKay.arrival_alert:
        _setArrivalAlert(selectedBusData);
        break;
      case AppLocalKay.bus_tracker:
        _showTripHistory(selectedBusData);
        break;
      case AppLocalKay.report_incident:
        _reportProblem(selectedBusData);
        break;
    }
  }

  void _showTripHistory(BusClass selectedBusData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('  رحلات ${selectedBusData.childName}'),
        backgroundColor: AppColor.primaryColor(context),
      ),
    );
  }

  void _reportProblem(BusClass selectedBusData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.report_incident.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.select_problem.tr()}${selectedBusData.childName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalKay.incident_report.tr(),
                    style: AppTextStyle.bodyMedium(context),
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            child: Text(AppLocalKay.send.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BusClass selectedBusData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency_rounded, color: AppColor.errorColor(context)),
            SizedBox(width: 8.w),
            Text(AppLocalKay.emergency_management.tr(), style: AppTextStyle.bodyMedium(context)),
          ],
        ),
        content: Text(AppLocalKay.emergency_alert.tr(), style: AppTextStyle.bodySmall(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalKay.alert_sent.tr(),
                    style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
                  ),
                  backgroundColor: AppColor.errorColor(context),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.errorColor(context)),
            child: Text(
              AppLocalKay.send_to_all.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
