import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_all_buses_status.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_bus_details.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_buses_selector.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_main_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_quick_overview.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_safety_alerts.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/fleet_management.dart';

class AdminBusTrackingScreen extends StatefulWidget {
  const AdminBusTrackingScreen({super.key});

  @override
  State<AdminBusTrackingScreen> createState() => _AdminBusTrackingScreenState();
}

class _AdminBusTrackingScreenState extends State<AdminBusTrackingScreen>
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

        final selectedBusData = state.selectedAdminBus;
        if (selectedBusData == null) {
          return Scaffold(body: Center(child: Text(AppLocalKay.no_buses.tr())));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFD),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      AppLocalKay.bus_title.tr(),
                      style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AdminBusesSelector(
                    selectedBus: selectedBusData.busNumber,
                    buses: state.buses,
                    onBusSelected: (busNumber) {
                      context.read<BusCubit>().selectAdminBus(busNumber);
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: AdminQuickOverview()),
                SliverToBoxAdapter(
                  child: AdminMainTrackingCard(
                    selectedBusData: selectedBusData,
                    busAnimation: _busAnimation,
                    onCallDriver: () => _callDriver(selectedBusData),
                    onRefreshLocation: () => _refreshLocation(selectedBusData),
                    onSendAlert: () => _sendAlert(selectedBusData),
                  ),
                ),
                SliverToBoxAdapter(child: AdminAllBusesStatus(allBusesData: state.buses)),
                SliverToBoxAdapter(child: AdminBusDetails(selectedBusData: selectedBusData)),
                SliverToBoxAdapter(child: FleetManagement(selectedBusData: selectedBusData)),
                SliverToBoxAdapter(
                  child: AdminSafetyAlerts(
                    onFeatureTap: (feature) => _handleSafetyFeature(feature, selectedBusData),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: AdminEmergencyButton(onPressed: _showEmergencyDialog),
        );
      },
    );
  }

  // Action Methods
  void _callDriver(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.ConnectDriverHint.tr()} ${busData.driverName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalKay.Connect.tr()),
          ),
        ],
      ),
    );
  }

  void _refreshLocation(dynamic busData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalKay.refresh_location.tr()} ${busData.busName}'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _sendAlert(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.send_alert.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.driver_name.tr().replaceAll('{{name}}', busData.busName)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalKay.alert_sent_success.tr()),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            child: Text(AppLocalKay.send.tr()),
          ),
        ],
      ),
    );
  }

  void _handleSafetyFeature(String feature, dynamic busData) {
    switch (feature) {
      case 'تنبيه عام':
        _sendGeneralAlert();
        break;
      case 'تقرير حادث':
        _reportAccident(busData);
        break;
      case 'اتصال الطوارئ':
        _emergencyCall(busData);
        break;
    }
  }

  void _sendGeneralAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.safety_general_alert.tr()),
        content: Text(AppLocalKay.emergency_content.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalKay.general_alert_sent.tr()),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            child: Text(AppLocalKay.emergency_send_all.tr()),
          ),
        ],
      ),
    );
  }

  void _reportAccident(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.safety_accident_report.tr()),
        content: Text('${AppLocalKay.bus_name.tr().replaceAll('{{name}}', busData.busName)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalKay.accident_reported.tr()),
                  backgroundColor: const Color(0xFFF44336),
                ),
              );
            },
            child: Text(AppLocalKay.send.tr()),
          ),
        ],
      ),
    );
  }

  void _emergencyCall(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.safety_emergency_call.tr()),
        content: Text('${AppLocalKay.bus_name.tr().replaceAll('{{name}}', busData.busName)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalKay.call.tr()),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.emergency_all_buses.tr()),
        content: Text(AppLocalKay.emergency_content.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalKay.general_alert_sent.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(AppLocalKay.emergency_send_all.tr()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
