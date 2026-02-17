import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_bus_details.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_buses_selector.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_main_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_quick_overview.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_safety_alerts.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/fleet_management.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

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
    // Fetch real bus data on init
    context.read<HomeCubit>().getData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _busAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  /// Maps [BusDataModel] from API to [BusModel] used in UI
  List<BusModel> _mapBusData(List<BusDataModel> apiData) {
    return List.generate(apiData.length, (index) {
      final bus = apiData[index];
      final lineName = bus.lineNameAr ?? "";

      // Parse stops from the API lineNameAr field (e.g., "القادسية/اليرموك")
      final List<String> rawStops = lineName
          .split(RegExp(r'[/-]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      List<Map<String, dynamic>> stops = [
        {
          'name': 'المدرسة',
          'alignment': 0.0,
          'icon': Icons.school_rounded,
          'color': const Color(0xFF2196F3),
        },
      ];

      if (rawStops.isEmpty) {
        // Fallback if no stops found
        stops.add({
          'name': 'نقطة الوصول',
          'alignment': 1.0,
          'icon': Icons.flag_rounded,
          'color': const Color(0xFF4CAF50),
        });
      } else {
        // Distribute stops along the path
        for (int i = 0; i < rawStops.length; i++) {
          final isLast = i == rawStops.length - 1;
          // Calculate alignment: start from 0.3 and go to 1.0
          final double alignment =
              0.3 + (i * (0.7 / (rawStops.length > 1 ? rawStops.length - 1 : 1)));

          stops.add({
            'name': rawStops[i],
            'alignment': isLast ? 1.0 : alignment.clamp(0.3, 0.9),
            'icon': isLast ? Icons.flag_rounded : Icons.location_on_rounded,
            'color': isLast ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
          });
        }
      }

      return BusModel(
        busNumber: bus.busCode?.toString() ?? "-",
        busName: bus.plateNo ?? "-",
        driverName: bus.driverNameAr ?? "-",
        driverPhone: "-", // Not available in BusDataModel
        currentLocation: bus.addressAr ?? "-",
        nextStop: "-",
        estimatedTime: "-",
        distance: "-",
        speed: "-",
        capacity: bus.busSets?.toString() ?? "-",
        occupiedSeats: "0",
        status: "نشط",
        busColor: const Color(0xFF9C27B0), // Default premium color
        route: bus.lineNameAr ?? "-",
        attendanceRate: "0%",
        fuelLevel: "100%",
        maintenanceStatus: "جيد",
        studentsOnBoard: "0",
        supervisorName: bus.supervisorNameAr1,
        sectionName: bus.sectionNameAr,
        stops: stops,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.busDataStatus.data != current.busDataStatus.data &&
          current.busDataStatus.isSuccess,
      listener: (context, homeState) {
        final realBuses = _mapBusData(homeState.busDataStatus.data ?? []);
        context.read<BusCubit>().updateAdminBuses(realBuses);
      },
      child: BlocBuilder<BusCubit, BusState>(
        builder: (context, busState) {
          final buses = busState.buses;
          final selectedBusData = busState.selectedAdminBus;

          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final busStatus = homeState.busDataStatus;

              if (busStatus.isLoading && buses.isEmpty) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (busStatus.isFailure && buses.isEmpty) {
                return Scaffold(
                  body: Center(child: Text(busStatus.error ?? "Error loading buses")),
                );
              }

              if (buses.isEmpty) {
                return Scaffold(body: Center(child: Text(AppLocalKay.no_buses.tr())));
              }

              // The selectedBusData is now synced via BusCubit
              final displaySelectedBus = selectedBusData ?? buses.first;

              return Scaffold(
                backgroundColor: const Color(0xFFF8FAFD),
                body: SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              AppLocalKay.bus_title.tr(),
                              style: AppTextStyle.titleLarge(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: AdminBusesSelector(
                          selectedBus: displaySelectedBus.busNumber,
                          buses: buses,
                          onBusSelected: (busNumber) {
                            context.read<BusCubit>().selectAdminBus(busNumber);
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(child: AdminQuickOverview()),
                      SliverToBoxAdapter(
                        child: AdminMainTrackingCard(
                          selectedBusData: displaySelectedBus,
                          busAnimation: _busAnimation,
                          onCallDriver: () => _callDriver(displaySelectedBus),
                          onRefreshLocation: () => _refreshLocation(displaySelectedBus),
                          onSendAlert: () => _sendAlert(displaySelectedBus),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: AdminBusDetails(selectedBusData: displaySelectedBus),
                      ),
                      SliverToBoxAdapter(
                        child: FleetManagement(selectedBusData: displaySelectedBus),
                      ),
                      SliverToBoxAdapter(
                        child: AdminSafetyAlerts(
                          onFeatureTap: (feature) =>
                              _handleSafetyFeature(feature, displaySelectedBus),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: AdminEmergencyButton(onPressed: _showEmergencyDialog),
              );
            },
          );
        },
      ),
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
          ElevatedButton(onPressed: () {}, child: Text(AppLocalKay.Connect.tr())),
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
