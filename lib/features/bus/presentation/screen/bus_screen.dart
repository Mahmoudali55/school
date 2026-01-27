import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:my_template/features/bus/presentation/screen/widget/student/safety_features.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/schedule_section_widget.dart';
import 'package:share_plus/share_plus.dart';

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
    context.read<BusCubit>().getBusData('student');
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
    if (context.read<BusCubit>().state.selectedAdminBus == null) return;
    final bus = context.read<BusCubit>().state.selectedAdminBus!;

    switch (feature) {
      case AppLocalKay.arrival_alert:
        _setArrivalAlert();
        break;
      case AppLocalKay.share_location:
        _shareLocation(bus);
        break;
      case AppLocalKay.urgent_call:
        _showEmergencyDialog();
        break;
    }
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) {
        int tempSelected = _selectedAlertMinutes;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                AppLocalKay.arrival_alert.tr(),
                style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر موعد التنبيه قبل وصول الحافلة:',
                    style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildChoiceChip(
                        5,
                        "5 ثواني (تجربة)",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                      _buildChoiceChip(
                        5 * 60,
                        "5 دقائق",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                      _buildChoiceChip(
                        10 * 60,
                        "10 دقائق",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                      _buildChoiceChip(
                        15 * 60,
                        "15 دقيقة",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                    ],
                  ),
                  if (tempSelected != 0) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: TextButton.icon(
                        onPressed: () => setDialogState(() => tempSelected = 0),
                        icon: Icon(
                          Icons.notifications_off_outlined,
                          color: AppColor.errorColor(context),
                          size: 20,
                        ),
                        label: Text(
                          AppLocalKay.cancel_alert.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: AppColor.errorColor(context)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedAlertMinutes = tempSelected);
                    Navigator.pop(context);
                    _scheduleAlert(tempSelected);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor(context)),
                  child: Text(
                    AppLocalKay.confirm.tr(),
                    style: AppTextStyle.bodyMedium(context, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _scheduleAlert(int durationInSeconds) {
    _alertTimer?.cancel();
    if (durationInSeconds > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم ضبط التنبيه بعد ${durationInSeconds < 60 ? '$durationInSeconds ثواني' : '${durationInSeconds ~/ 60} دقيقة'}",
          ),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );

      _alertTimer = Timer(Duration(seconds: durationInSeconds), () async {
        // Play Sound
        try {
          await _audioPlayer.play(
            UrlSource('https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3'),
          );
        } catch (e) {
          print("Error playing sound: $e");
        }

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.access_alarm, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    AppLocalKay.alert_arrived.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                AppLocalKay.alert_arrived_desc.tr(),
                style: AppTextStyle.bodySmall(context),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _audioPlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalKay.ok.tr(), style: AppTextStyle.bodyMedium(context)),
                ),
              ],
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalKay.alert_cancel.tr()),
          backgroundColor: AppColor.accentColor(context),
        ),
      );
    }
  }

  Widget _buildChoiceChip(int value, String label, int currentSelection, Function(int) onSelected) {
    final isSelected = value == currentSelection;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(selected ? value : 0),
      selectedColor: AppColor.primaryColor(context),
      backgroundColor: AppColor.grey200Color(context),
      labelStyle: TextStyle(
        color: isSelected ? AppColor.whiteColor(context) : AppColor.blackColor(context),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _shareLocation(BusModel bus) {
    if (bus.lat != null && bus.lng != null) {
      final String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=${bus.lat},${bus.lng}";
      Share.share("${AppLocalKay.share_location.tr()} ${bus.busNumber}\n$googleMapsUrl");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalKay.location_not_available.tr()),
          backgroundColor: AppColor.errorColor(context),
        ),
      );
    }
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
          backgroundColor: AppColor.whiteColor(context),
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
