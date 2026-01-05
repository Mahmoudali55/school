import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return const Scaffold(body: Center(child: Text("لا توجد حافلات")));
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
                // Buses Selector
                SliverToBoxAdapter(
                  child: AdminBusesSelector(
                    selectedBus: selectedBusData.busNumber,
                    buses: state.buses,
                    onBusSelected: (busNumber) {
                      context.read<BusCubit>().selectAdminBus(busNumber);
                    },
                  ),
                ),

                // Quick Overview
                const SliverToBoxAdapter(child: AdminQuickOverview()),

                // Main Tracking Card
                SliverToBoxAdapter(
                  child: AdminMainTrackingCard(
                    selectedBusData: selectedBusData,
                    busAnimation: _busAnimation,
                    onCallDriver: () => _callDriver(selectedBusData),
                    onRefreshLocation: () => _refreshLocation(selectedBusData),
                    onSendAlert: () => _sendAlert(selectedBusData),
                  ),
                ),

                // All Buses Status
                SliverToBoxAdapter(child: AdminAllBusesStatus(allBusesData: state.buses)),

                // Bus Details
                SliverToBoxAdapter(child: AdminBusDetails(selectedBusData: selectedBusData)),

                // Fleet Management
                SliverToBoxAdapter(child: FleetManagement(selectedBusData: selectedBusData)),

                // Safety & Alerts
                SliverToBoxAdapter(
                  child: AdminSafetyAlerts(
                    onFeatureTap: (feature) => _handleSafetyFeature(feature, selectedBusData),
                  ),
                ),
              ],
            ),
          ),

          // Emergency Button
          floatingActionButton: AdminEmergencyButton(onPressed: _showEmergencyDialog),
        );
      },
    );
  }

  // Action methods
  void _callDriver(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالسائق'),
        content: Text('هل تريد الاتصال بالسائق ${busData.driverName}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال
            },
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _refreshLocation(dynamic busData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تحديث موقع ${busData.busName}'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _sendAlert(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال تنبيه'),
        content: Text('إرسال تنبيه لسائق ${busData.busName}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال التنبيه بنجاح'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text('إرسال'),
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
        title: const Text('تنبيه عام'),
        content: const Text('إرسال تنبيه عام لجميع الحافلات'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال التنبيه العام'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text('إرسال للجميع'),
          ),
        ],
      ),
    );
  }

  void _reportAccident(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقرير حادث'),
        content: Text('الإبلاغ عن حادث لحافلة ${busData.busName}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم الإبلاغ عن الحادث'),
                  backgroundColor: Color(0xFFF44336),
                ),
              );
            },
            child: const Text('إبلاغ'),
          ),
        ],
      ),
    );
  }

  void _emergencyCall(dynamic busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: Text('الاتصال بجهات الطوارئ لحافلة ${busData.busName}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال بالطوارئ
            },
            child: const Text('اتصال'),
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
            const Icon(Icons.emergency_rounded, color: Colors.red),
            SizedBox(width: 8.w),
            const Text('طوارئ - جميع الحافلات'),
          ],
        ),
        content: const Text('إرسال تنبيه طوارئ لجميع الحافلات والجهات المعنية؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال تنبيه الطوارئ لجميع الحافلات'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إرسال للجميع'),
          ),
        ],
      ),
    );
  }
}
