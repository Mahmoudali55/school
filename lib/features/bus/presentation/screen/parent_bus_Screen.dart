import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentBusTrackingScreen extends StatefulWidget {
  const ParentBusTrackingScreen({super.key});

  @override
  State<ParentBusTrackingScreen> createState() => _ParentBusTrackingScreenState();
}

class _ParentBusTrackingScreenState extends State<ParentBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;
  Timer? _alertTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _selectedAlertMinutes = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    final code = int.tryParse(HiveMethods.getUserCode()) ?? 0;
    final cubit = context.read<BusCubit>();
    cubit.getBusData('parent', code: code).then((_) {
      // After getting children buses, load bus line info for first child
      final firstChild = cubit.state.parentChildrenBuses.firstOrNull;
      if (firstChild != null) {
        final studentCode = int.tryParse(firstChild.id) ?? 0;
        if (studentCode > 0) {
          cubit.busLine(studentCode);
        }
      }
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _busAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  void dispose() {
    _animationController.dispose();
    _alertTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: BlocBuilder<BusCubit, BusState>(
          builder: (context, state) {
            final selectedBusData = state.selectedClass;
            final bool isLoading = state.isLoading;

            return CustomScrollView(
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

                if (isLoading && state.parentChildrenBuses.isEmpty)
                  const SliverFillRemaining(child: Center(child: CustomLoading()))
                else if (state.error != null && state.parentChildrenBuses.isEmpty)
                  SliverFillRemaining(child: Center(child: Text(state.error ?? "حدث خطأ ما")))
                else if (state.parentChildrenBuses.isEmpty)
                  const SliverFillRemaining(child: Center(child: CustomLoading()))
                else ...[
                  // Children Selector
                  SliverToBoxAdapter(
                    child: ChildrenSelector(
                      children: state.parentChildrenBuses.map((e) => e.childName ?? "").toList(),
                      selectedChild: selectedBusData?.childName ?? "",
                      childrenBusData: state.parentChildrenBuses,
                      onSelected: (childName) {
                        final selected = state.parentChildrenBuses.firstWhere(
                          (e) => e.childName == childName,
                        );
                        context.read<BusCubit>().selectClass(selected.id);

                        final studentCode = int.tryParse(selected.id) ?? 0;
                        if (studentCode > 0) {
                          context.read<BusCubit>().busLine(studentCode);
                        }
                      },
                    ),
                  ),

                  // Quick Overview
                  // Quick Overview
                  // SliverToBoxAdapter(
                  //   child: QuickOverview(
                  //     childrenCount: state.parentChildrenBuses.length,
                  //     inBusCount: state.parentChildrenBuses
                  //         .where((c) => c.status == 'في الطريق')
                  //         .length,
                  //     nearestArrival: state.overviewStats['closestArrival'] ?? "---",
                  //     safetyStatus: "١٠٠٪",
                  //     nextStop: selectedBusData?.nextStop,
                  //     driverName: selectedBusData?.driverName,
                  //     busNumber: selectedBusData?.busNumber,
                  //     attendanceRate: selectedBusData?.attendanceRate,
                  //     lastUpdate: "تحديث لحظي",
                  //     onItemTapped: (type) => _handleOverviewItemTapped(type, state),
                  //   ),
                  // ),
                  if (selectedBusData != null) ...[
                    // Main Tracking Card
                    SliverToBoxAdapter(
                      child: MainTrackingCard(
                        selectedBusData: selectedBusData,
                        busAnimation: _busAnimation,
                        onCallDriver: () => _callDriver(selectedBusData),
                        onShareLocation: () => _shareLocation(selectedBusData),
                        onSetArrivalAlert: () => _setArrivalAlert(selectedBusData),
                        onRouteLineTapped: () => _showAllStationsBottomSheet(state),
                      ),
                    ),

                    // All Children Status
                    SliverToBoxAdapter(
                      child: AllChildrenStatus(childrenBusData: state.parentChildrenBuses),
                    ),

                    // Bus Details
                    SliverToBoxAdapter(
                      child: BusDetails(
                        selectedBusData: selectedBusData,
                        onRouteLineTapped: () => _showAllStationsBottomSheet(state),
                      ),
                    ),
                  ] else if (isLoading) ...[
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      ),
      // Emergency Button
      floatingActionButton: BlocBuilder<BusCubit, BusState>(
        builder: (context, state) {
          if (state.selectedClass == null) return const SizedBox.shrink();
          return ParentEmergencyButton(onPressed: () => _showEmergencyDialog(state.selectedClass!));
        },
      ),
    );
  }

  // ... (existing imports)

  void _callDriver(BusClass selectedBusData) {
    final busState = context.read<BusCubit>().state;
    final String? phoneNumber = busState.busStatus.data?.firstOrNull?.mobileNo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalKay.ConnectDriverHint.tr()}${selectedBusData.driverName}؟'),
            if (phoneNumber != null) ...[
              SizedBox(height: 8.h),
              Text(
                phoneNumber,
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: AppColor.primaryColor(context)),
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
            onPressed: () async {
              Navigator.pop(context);
              if (phoneNumber != null && phoneNumber.isNotEmpty) {
                final uri = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لا يمكن فتح تطبيق الهاتف'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('رقم الهاتف غير متوفر'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalKay.Connect.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _shareLocation(BusClass selectedBusData) {
    if (selectedBusData.lat != null && selectedBusData.lng != null) {
      final String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=${selectedBusData.lat},${selectedBusData.lng}";
      Share.share(
        "${AppLocalKay.share_location.tr()} ${selectedBusData.childName}\n$googleMapsUrl",
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الموقع غير متاح حالياً"), backgroundColor: Colors.red),
      );
    }
  }

  void _setArrivalAlert(BusClass selectedBusData) {
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
                    AppLocalKay.pick_up_time.tr(),
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.greyColor(context)),
                  ),
                  Gap(16.h),
                  Wrap(
                    spacing: 8.w,
                    children: [
                      _buildChoiceChip(
                        5,
                        "5 د",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                      _buildChoiceChip(
                        10,
                        "10 د",
                        tempSelected,
                        (val) => setDialogState(() => tempSelected = val),
                      ),
                      _buildChoiceChip(
                        15,
                        "15 د",
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
                          "إلغاء التنبيه",
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
                    if (_selectedAlertMinutes > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("تم ضبط التنبيه قبل $_selectedAlertMinutes دقائق"),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم إلغاء التنبيه"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
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

  Widget _buildChoiceChip(int value, String label, int currentSelection, Function(int) onSelected) {
    final isSelected = value == currentSelection;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(selected ? value : 0),
      selectedColor: AppColor.primaryColor(context),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  void _handleOverviewItemTapped(String type, BusState state) {
    String message = "";
    IconData icon = Icons.info_outline;
    final selectedBus = state.selectedClass;

    switch (type) {
      case 'children':
        final names = state.parentChildrenBuses.map((e) => e.childName).join('، ');
        message = "الأبناء: $names";
        icon = Icons.family_restroom_rounded;
        break;
      case 'in_bus':
        final inBus = state.parentChildrenBuses.where((e) => e.status == 'في الطريق').toList();
        if (inBus.isEmpty) {
          message = "لا يوجد أبناء في الحافلة حالياً";
        } else {
          message = "في الحافلة: ${inBus.map((e) => e.childName).join('، ')}";
        }
        icon = Icons.directions_bus_rounded;
        break;
      case 'arrival':
        if (state.parentChildrenBuses.isEmpty) {
          message = "لا توجد بيانات وصول";
        } else {
          final closest = state.parentChildrenBuses.first;
          message = "أقرب وصول: ${closest.estimatedArrival} لـ ${closest.childName}";
        }
        icon = Icons.schedule_rounded;
        break;
      case 'attendance':
        if (selectedBus != null) {
          message = "نسبة حضور ${selectedBus.childName}: ${selectedBus.attendanceRate}";
        } else {
          message = "اختر ابناً لعرض نسبة الحضور";
        }
        icon = Icons.analytics_rounded;
        break;
      case 'driver':
        if (selectedBus != null) {
          message = "سائق الحافلة: ${selectedBus.driverName}";
        } else {
          message = "معلومات السائق غير متوفرة حالياً";
        }
        icon = Icons.person_pin_rounded;
        break;
      case 'bus':
        if (selectedBus != null) {
          message = "رقم الحافلة: ${selectedBus.busNumber}";
        } else {
          message = "اختر ابناً لعرض رقم الحافلة";
        }
        icon = Icons.confirmation_number_rounded;
        break;
      case 'stop':
        if (selectedBus != null) {
          message = "المحطة القادمة: ${selectedBus.nextStop}";
        } else {
          message = "المحطة القادمة غير محددة بعد";
        }
        icon = Icons.near_me_rounded;
        break;
      case 'status':
        message = "حالة النظام: مستقر وجميع الحافلات في المسار الصحيح";
        icon = Icons.verified_rounded;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.primaryColor(context),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _showTripHistory(BusClass selectedBusData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('  رحلات ${selectedBusData.childName}'),
        backgroundColor: AppColor.primaryColor(context),
      ),
    );
  }

  void _showAllStationsBottomSheet(BusState state) {
    final busLines = state.busStatus.data ?? [];
    //final selectedBus = state.selectedClass;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(Icons.route_rounded, color: AppColor.primaryColor(context), size: 24.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalKay.bus_route.tr(),
                            style: AppTextStyle.titleSmall(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (busLines.first.busCode != null)
                            Text(
                              '${AppLocalKay.bus_number.tr()}: ${busLines.first.busCode}',
                              style: AppTextStyle.bodySmall(
                                context,
                              ).copyWith(color: AppColor.greyColor(context)),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: AppColor.greyColor(context)),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey[200]),

              // Stations List
              Expanded(
                child: busLines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off_rounded,
                              size: 48.w,
                              color: AppColor.greyColor(context),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'لا توجد محطات متاحة',
                              style: AppTextStyle.bodyMedium(
                                context,
                              ).copyWith(color: AppColor.greyColor(context)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemCount: busLines.length,
                        itemBuilder: (context, index) {
                          final busLine = busLines[index];
                          final isFirst = index == 0;
                          final isLast = index == busLines.length - 1;

                          return _buildStationItem(
                            context,
                            stationName: busLine.busLineName,
                            stationDetails: busLine.busSectionName,
                            driverName: busLine.busDriverName,
                            isFirst: isFirst,
                            isLast: isLast,
                            index: index,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStationItem(
    BuildContext context, {
    required String stationName,
    required String stationDetails,
    required String driverName,
    required bool isFirst,
    required bool isLast,
    required int index,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColor.secondAppColor(context)
                    : isLast
                    ? AppColor.primaryColor(context)
                    : AppColor.greyColor(context).withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst
                      ? AppColor.secondAppColor(context)
                      : isLast
                      ? AppColor.primaryColor(context)
                      : AppColor.greyColor(context),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  isFirst
                      ? Icons.home_rounded
                      : isLast
                      ? Icons.school_rounded
                      : Icons.location_on_rounded,
                  color: isFirst || isLast ? Colors.white : AppColor.greyColor(context),
                  size: 14.w,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 50.h,
                color: AppColor.greyColor(context).withOpacity(0.3),
              ),
          ],
        ),

        SizedBox(width: 12.w),

        // Station info
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColor.secondAppColor(context).withOpacity(0.1)
                  : isLast
                  ? AppColor.primaryColor(context).withOpacity(0.1)
                  : AppColor.greyColor(context).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isFirst
                    ? AppColor.secondAppColor(context).withOpacity(0.3)
                    : isLast
                    ? AppColor.primaryColor(context).withOpacity(0.3)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stationName,
                        style: AppTextStyle.bodyMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: AppColor.primaryColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  stationDetails,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.person_rounded, size: 14.w, color: AppColor.greyColor(context)),
                    SizedBox(width: 4.w),
                    Text(
                      driverName,
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
