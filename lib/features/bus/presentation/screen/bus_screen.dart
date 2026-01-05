import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_Information_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/route_progress_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/safety_features.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/schedule_section_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
    super.dispose();
  }

  // =========================== إجراءات ===========================
  void _refreshLocation() {
    context.read<BusCubit>().getBusData('student');
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

  void _callDriver(String driverName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('\ ${AppLocalKay.ConnectDriverHint.tr()}   $driverName؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.Connect.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _handleSafetyFeature(String feature) {
    switch (feature) {
      case AppLocalKay.arrival_alert:
        _setArrivalAlert();
        break;
      case AppLocalKay.share_location:
        _shareLocation();
        break;
      case AppLocalKay.urgent_call:
        _showEmergencyDialog();
        break;
    }
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.arrival_alert.tr()),
        content: const Text('سيتم إشعارك قبل وصول الحافلة بـ 5 دقائق'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.confirm.tr()),
          ),
        ],
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalKay.share_location.tr()), backgroundColor: Color(0xFF4CAF50)),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.emergency_rounded, color: Colors.red),
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
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              AppLocalKay.send.tr(),
              style: AppTextStyle.bodyMedium(context, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // =========================== Build ===========================
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final selectedBus = state.selectedAdminBus;
        if (selectedBus == null) {
          return const Scaffold(body: Center(child: Text("لا توجد بيانات متاحة")));
        }

        // Mock stops and schedule for now as they are not in the model yet
        final List<Map<String, dynamic>> stops = [
          {'name': 'المنزل', 'time': '6:30 ص', 'passed': true, 'current': false},
          {'name': 'شارع التحلية', 'time': '6:45 ص', 'passed': true, 'current': false},
          {'name': 'ميدان الملكة', 'time': '7:00 ص', 'passed': false, 'current': true},
          {'name': 'محطة الجامعة', 'time': '7:15 ص', 'passed': false, 'current': false},
          {'name': 'المدرسة', 'time': '7:30 ص', 'passed': false, 'current': false},
        ];

        final List<Map<String, dynamic>> schedule = [
          {'period': AppLocalKay.morning.tr(), 'pickup': '6:30 ص', 'arrival': '7:30 ص'},
          {'period': AppLocalKay.evening.tr(), 'pickup': '12:30 م', 'arrival': '1:30 م'},
          {'period': AppLocalKay.night.tr(), 'pickup': '3:30 م', 'arrival': '4:30 م'},
        ];

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
                  child: BusTrackingCard(
                    busData: selectedBus, // This will need updating in the widget itself
                    stops: stops,
                    busAnimation: _busAnimation,
                    isBusMoving: _isBusMoving,
                    refreshLocation: _refreshLocation,
                    toggleBusMovement: _toggleBusMovement,
                    callDriver: () => _callDriver(selectedBus.driverName),
                  ),
                ),
                SliverToBoxAdapter(child: RouteProgress(stops: stops)),
                SliverToBoxAdapter(child: BusInformation(busData: selectedBus)),
                SliverToBoxAdapter(child: ScheduleSection(schedule: schedule)),
                SliverToBoxAdapter(child: SafetyFeatures(onFeatureTap: _handleSafetyFeature)),
              ],
            ),
          ),
          floatingActionButton: EmergencyButton(showDialogCallback: () => _showEmergencyDialog()),
        );
      },
    );
  }
}
