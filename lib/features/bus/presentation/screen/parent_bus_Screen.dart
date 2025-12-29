import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
  State<ParentBusTrackingScreen> createState() =>
      _ParentBusTrackingScreenState();
}

class _ParentBusTrackingScreenState extends State<ParentBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;
  String _selectedChild = "أحمد";
  final List<String> _children = ["أحمد", "ليلى", "محمد"];
  Map<String, dynamic> _selectedBusData = {};
  List<Map<String, dynamic>> _childrenBusData = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
  }

  void _initializeData() {
    _childrenBusData = [
      {
        'childName': 'أحمد',
        'busNumber': 'BUS-2024',
        'driverName': 'أحمد محمد',
        'driverPhone': '+966500000000',
        'currentLocation': 'شارع الملك فهد',
        'nextStop': 'محطة الجامعة',
        'estimatedTime': '7 دقائق',
        'distance': '1.2 كم',
        'speed': '45 كم/ساعة',
        'capacity': '40 طالب',
        'occupiedSeats': '32',
        'status': 'في الطريق',
        'lastUpdate': 'منذ دقيقتين',
        'onBoard': true,
        'attendance': 'حاضر',
        'school': 'مدرسة النخبة الثانوية',
        'grade': 'الصف العاشر',
        'busColor': Color(0xFF4CAF50),
      },
      {
        'childName': 'ليلى',
        'busNumber': 'BUS-2025',
        'driverName': 'محمد علي',
        'driverPhone': '+966500000001',
        'currentLocation': 'حي السلام',
        'nextStop': 'سوق المدينة',
        'estimatedTime': '15 دقيقة',
        'distance': '3.5 كم',
        'speed': '35 كم/ساعة',
        'capacity': '35 طالب',
        'occupiedSeats': '28',
        'status': 'في المحطة',
        'lastUpdate': 'منذ 5 دقائق',
        'onBoard': false,
        'attendance': 'في الطريق',
        'school': 'مدرسة الأمل الابتدائية',
        'grade': 'الصف الرابع',
        'busColor': Color(0xFF2196F3),
      },
      {
        'childName': 'محمد',
        'busNumber': 'BUS-2026',
        'driverName': 'خالد أحمد',
        'driverPhone': '+966500000002',
        'currentLocation': 'حي الروضة',
        'nextStop': 'حديقة الحيوانات',
        'estimatedTime': '22 دقيقة',
        'distance': '5.8 كم',
        'speed': '40 كم/ساعة',
        'capacity': '30 طالب',
        'occupiedSeats': '25',
        'status': 'في الطريق',
        'lastUpdate': 'منذ 3 دقائق',
        'onBoard': true,
        'attendance': 'حاضر',
        'school': 'مدرسة المستقبل المتوسطة',
        'grade': 'الصف السابع',
        'busColor': Color(0xFFFF9800),
      },
    ];

    _selectedBusData = _childrenBusData.first;
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _busAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                children: _children,
                selectedChild: _selectedChild,
                childrenBusData: _childrenBusData,
                onSelected: (childName) {
                  setState(() {
                    _selectedChild = childName;
                    _selectedBusData = _childrenBusData.firstWhere(
                      (data) => data['childName'] == childName,
                    );
                  });
                },
              ),
            ),

            // Quick Overview
            SliverToBoxAdapter(
              child: QuickOverview(
                childrenCount: _children.length,
                inBusCount: _childrenBusData
                    .where((c) => c['onBoard'] == true)
                    .length,
                nearestArrival: "7 د",
                safetyStatus: "٣/٣",
              ),
            ),

            // Main Tracking Card
            SliverToBoxAdapter(
              child: MainTrackingCard(
                selectedBusData: _selectedBusData,
                busAnimation: _busAnimation,
                onCallDriver: _callDriver,
                onShareLocation: _shareLocation,
                onSetArrivalAlert: _setArrivalAlert,
              ),
            ),

            // All Children Status
            SliverToBoxAdapter(
              child: AllChildrenStatus(childrenBusData: _childrenBusData),
            ),

            // Bus Details
            SliverToBoxAdapter(
              child: BusDetails(selectedBusData: _selectedBusData),
            ),

            // Safety & Alerts
            SliverToBoxAdapter(
              child: SafetyAlerts(onFeatureTap: _handleSafetyFeature),
            ),
          ],
        ),
      ),

      // Emergency Button
      floatingActionButton: ParentEmergencyButton(
        onPressed: _showEmergencyDialog,
      ),
    );
  }

  // دوال الإجراءات
  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalKay.call_driver.tr(),
          style: AppTextStyle.bodyMedium(context),
        ),
        content: Text(
          '${AppLocalKay.ConnectDriverHint.tr()}${_selectedBusData['driverName']}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.cancel.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال
            },
            child: Text(
              AppLocalKay.Connect.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalKay.share_location.tr()} ${_selectedBusData['childName']}',
        ),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalKay.arrival_alert.tr(),
          style: AppTextStyle.bodyMedium(context),
        ),
        content: Text(
          '${AppLocalKay.alert_message.tr()}${_selectedBusData['childName']} بـ 10 دقائق',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.confirm.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
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
      case AppLocalKay.bus_tracker:
        _showTripHistory();
        break;
      case AppLocalKay.report_incident:
        _reportProblem();
        break;
    }
  }

  void _showTripHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('  رحلات ${_selectedBusData['childName']}'),
        backgroundColor: AppColor.primaryColor(context),
      ),
    );
  }

  void _reportProblem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalKay.report_incident.tr(),
          style: AppTextStyle.bodyMedium(context),
        ),
        content: Text(
          '${AppLocalKay.select_problem.tr()}${_selectedBusData['childName']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.cancel.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
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
            child: Text(
              AppLocalKay.send.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
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
            Text(
              AppLocalKay.emergency_management.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
          ],
        ),
        content: Text(
          AppLocalKay.emergency_alert.tr(),
          style: AppTextStyle.bodySmall(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.cancel.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalKay.alert_sent.tr(),
                    style: AppTextStyle.bodyMedium(
                      context,
                      color: AppColor.whiteColor(context),
                    ),
                  ),
                  backgroundColor: AppColor.errorColor(context),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.errorColor(context),
            ),
            child: Text(
              AppLocalKay.send_to_all.tr(),
              style: AppTextStyle.bodyMedium(
                context,
                color: AppColor.whiteColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
