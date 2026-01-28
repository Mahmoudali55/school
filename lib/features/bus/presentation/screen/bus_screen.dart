import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_Information_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/route_progress_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBusTrackingScreen extends StatefulWidget {
  const StudentBusTrackingScreen({super.key});

  @override
  State<StudentBusTrackingScreen> createState() => _StudentBusTrackingScreenState();
}

class _StudentBusTrackingScreenState extends State<StudentBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;
  bool _isBusMoving = true;
  int _selectedAlertMinutes = 0;
  Timer? _alertTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Fetch bus data
    context.read<BusCubit>().busLine(int.parse(HiveMethods.getUserCode()));
  }

  void _initializeAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _busAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _alertTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // =========================== إجراءات ===========================
  void _refreshLocation() {
    context.read<BusCubit>().busLine(int.parse(HiveMethods.getUserCode()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalKay.update_location.tr()),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _toggleBusMovement() {
    setState(() {
      _isBusMoving = !_isBusMoving;
      if (_isBusMoving) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    });
  }

  void _callDriver(String driverName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.ConnectDriverHint.tr()}   $driverName؟\n$phoneNumber'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
              canLaunchUrl(launchUri).then((bool result) {
                if (result) {
                  launchUrl(launchUri);
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Could not launch $phoneNumber")));
                }
              });
            },
            child: Text(AppLocalKay.Connect.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
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
                    style: AppTextStyle.bodyMedium(context),
                  ),
                  backgroundColor: AppColor.errorColor(context),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.errorColor(context)),
            child: Text(
              AppLocalKay.send.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  // =========================== Build ===========================
  // =========================== Build ===========================
  @override
  Widget build(BuildContext context) {
    // Mock stops and schedule as they are not yet in BusLine

    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: BlocBuilder<BusCubit, BusState>(
        builder: (context, state) {
          if (state.busStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.busStatus.isFailure) {
            return Center(child: Text(state.busStatus.error ?? "An error occurred"));
          }

          if (state.busStatus.isSuccess) {
            final busLines = state.busStatus.data ?? [];
            if (busLines.isEmpty) {
              return Center(child: Text("No Bus Found"));
            }

            final busLine = busLines.first;

            // Map BusLine to BusModel
            final selectedBus = BusModel(
              busNumber: busLine.plateNo,
              busName: busLine.busLineName,
              driverName: busLine.busDriverName,
              driverPhone: busLine.mobileNo,
              currentLocation: "الموقع الحالي غير متاح",
              nextStop: "---",
              estimatedTime: "---",
              distance: "---",
              speed: "---",
              capacity: busLine.busSets.toString(),
              occupiedSeats: busLine.busSetsUsed.toString(),
              status: busLine.busState == 1 ? "Active" : "Inactive",
              busColor: const Color(0xFF4CAF50),
              route: "مسار ${busLine.busLineName}",
              attendanceRate: "---",
              fuelLevel: "---",
              maintenanceStatus: "---",
              studentsOnBoard: busLine.busSetsUsed.toString(),
              supervisorName: busLine.busSupervisorName1,
              supervisorPhone: busLine.supMobileNo,
              busType: busLine.busType,
              modelYear: busLine.modelNo,
              sectionName: busLine.busSectionName,
              accountName: busLine.accountName,
            );

            // Dynamic Stops Parsing
            // Splitting "Station1/Station2/Station3" -> List
            List<String> routeStopsNames = busLine.busLineName
                .split('/')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            // Fallback if split results in empty (shouldn't happen if name exists)
            if (routeStopsNames.isEmpty) {
              routeStopsNames = [busLine.busLineName];
            }

            // Create stops list for UI
            final List<Map<String, dynamic>> dynamicStops = routeStopsNames.map((name) {
              return {'name': name, 'time': '---', 'passed': false, 'current': false};
            }).toList();

            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        AppLocalKay.bus_title.tr(),
                        style: AppTextStyle.titleLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BusTrackingCard(
                      busData: selectedBus,
                      stops: dynamicStops,
                      busAnimation: _busAnimation,
                      isBusMoving: _isBusMoving,
                      refreshLocation: _refreshLocation,
                      toggleBusMovement: _toggleBusMovement,
                      callDriver: () =>
                          _callDriver(selectedBus.driverName, selectedBus.driverPhone),
                    ),
                  ),
                  SliverToBoxAdapter(child: RouteProgress(stops: dynamicStops)),
                  SliverToBoxAdapter(child: BusInformation(busData: selectedBus)),
                ],
              ),
            );
          }

          // Show something while initial or waiting if not loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: EmergencyButton(showDialogCallback: () => _showEmergencyDialog()),
    );
  }
}
