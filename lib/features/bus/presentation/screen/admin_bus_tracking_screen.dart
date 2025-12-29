import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
  String _selectedBus = "BUS-2024";
  final List<String> _buses = ["BUS-2024", "BUS-2025", "BUS-2026", "BUS-2027"];
  Map<String, dynamic> _selectedBusData = {};
  List<Map<String, dynamic>> _allBusesData = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
  }

  void _initializeData() {
    _allBusesData = [
      {
        'busNumber': 'BUS-2024',
        'busName': 'الحافلة أ',
        'driverName': 'أحمد محمد',
        'driverPhone': '+966500000000',
        'currentLocation': 'شارع الملك فهد',
        'nextStop': 'محطة الجامعة',
        'estimatedTime': '7 دقائق',
        'distance': '1.2 كم',
        'speed': '45 كم/ساعة',
        'capacity': '40 طالب',
        'occupiedSeats': '32',
        'availableSeats': '8',
        'status': 'في الطريق',
        'lastUpdate': 'منذ دقيقتين',
        'route': 'الطريق الرئيسي',
        'studentsOnBoard': '32 طالب',
        'attendanceRate': '94%',
        'fuelLevel': '78%',
        'maintenanceStatus': 'جيد',
        'busColor': const Color(0xFF4CAF50),
        'routeColor': const Color(0xFF4CAF50),
      },
      {
        'busNumber': 'BUS-2025',
        'busName': 'الحافلة ب',
        'driverName': 'محمد علي',
        'driverPhone': '+966500000001',
        'currentLocation': 'حي السلام',
        'nextStop': 'سوق المدينة',
        'estimatedTime': '15 دقيقة',
        'distance': '3.5 كم',
        'speed': '35 كم/ساعة',
        'capacity': '35 طالب',
        'occupiedSeats': '28',
        'availableSeats': '7',
        'status': 'في المحطة',
        'lastUpdate': 'منذ 5 دقائق',
        'route': 'طريق الحي الشمالي',
        'studentsOnBoard': '28 طالب',
        'attendanceRate': '89%',
        'fuelLevel': '45%',
        'maintenanceStatus': 'يحتاج صيانة',
        'busColor': const Color(0xFF2196F3),
        'routeColor': const Color(0xFF2196F3),
      },
      {
        'busNumber': 'BUS-2026',
        'busName': 'الحافلة ج',
        'driverName': 'خالد أحمد',
        'driverPhone': '+966500000002',
        'currentLocation': 'حي الروضة',
        'nextStop': 'حديقة الحيوانات',
        'estimatedTime': '22 دقيقة',
        'distance': '5.8 كم',
        'speed': '40 كم/ساعة',
        'capacity': '30 طالب',
        'occupiedSeats': '25',
        'availableSeats': '5',
        'status': 'في الطريق',
        'lastUpdate': 'منذ 3 دقائق',
        'route': 'طريق الحي الشرقي',
        'studentsOnBoard': '25 طالب',
        'attendanceRate': '92%',
        'fuelLevel': '90%',
        'maintenanceStatus': 'ممتاز',
        'busColor': const Color(0xFFFF9800),
        'routeColor': const Color(0xFFFF9800),
      },
      {
        'busNumber': 'BUS-2027',
        'busName': 'الحافلة د',
        'driverName': 'سعيد حسن',
        'driverPhone': '+966500000003',
        'currentLocation': 'حي الأندلس',
        'nextStop': 'المستشفى العام',
        'estimatedTime': '18 دقيقة',
        'distance': '4.2 كم',
        'speed': '38 كم/ساعة',
        'capacity': '40 طالب',
        'occupiedSeats': '35',
        'availableSeats': '5',
        'status': 'متأخرة',
        'lastUpdate': 'منذ 4 دقائق',
        'route': 'طريق الحي الغربي',
        'studentsOnBoard': '35 طالب',
        'attendanceRate': '96%',
        'fuelLevel': '60%',
        'maintenanceStatus': 'جيد',
        'busColor': const Color(0xFF9C27B0),
        'routeColor': const Color(0xFF9C27B0),
      },
    ];

    _selectedBusData = _allBusesData.first;
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
            // Buses Selector
            SliverToBoxAdapter(
              child: AdminBusesSelector(
                selectedBus: _selectedBus,
                buses: _buses,
                allBusesData: _allBusesData,
                onBusSelected: (busNumber, busData) {
                  setState(() {
                    _selectedBus = busNumber;
                    _selectedBusData = busData;
                  });
                },
              ),
            ),

            // Quick Overview
            const SliverToBoxAdapter(child: AdminQuickOverview()),

            // Main Tracking Card
            SliverToBoxAdapter(
              child: AdminMainTrackingCard(
                selectedBusData: _selectedBusData,
                busAnimation: _busAnimation,
                onCallDriver: _callDriver,
                onRefreshLocation: _refreshLocation,
                onSendAlert: _sendAlert,
              ),
            ),

            // All Buses Status
            SliverToBoxAdapter(
              child: AdminAllBusesStatus(allBusesData: _allBusesData),
            ),

            // Bus Details
            SliverToBoxAdapter(
              child: AdminBusDetails(selectedBusData: _selectedBusData),
            ),

            // Fleet Management
            SliverToBoxAdapter(
              child: FleetManagement(selectedBusData: _selectedBusData),
            ),

            // Safety & Alerts
            SliverToBoxAdapter(
              child: AdminSafetyAlerts(onFeatureTap: _handleSafetyFeature),
            ),
          ],
        ),
      ),

      // Emergency Button
      floatingActionButton: AdminEmergencyButton(
        onPressed: _showEmergencyDialog,
      ),
    );
  }

  // Action methods
  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالسائق'),
        content: Text(
          'هل تريد الاتصال بالسائق ${_selectedBusData['driverName']}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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

  void _refreshLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تحديث موقع ${_selectedBusData['busName']}'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _sendAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال تنبيه'),
        content: Text('إرسال تنبيه لسائق ${_selectedBusData['busName']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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

  void _handleSafetyFeature(String feature) {
    switch (feature) {
      case 'تنبيه عام':
        _sendGeneralAlert();
        break;
      case 'تقرير حادث':
        _reportAccident();
        break;
      case 'اتصال الطوارئ':
        _emergencyCall();
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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

  void _reportAccident() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقرير حادث'),
        content: Text('الإبلاغ عن حادث لحافلة ${_selectedBusData['busName']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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

  void _emergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال طوارئ'),
        content: Text(
          'الاتصال بجهات الطوارئ لحافلة ${_selectedBusData['busName']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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
        content: const Text(
          'إرسال تنبيه طوارئ لجميع الحافلات والجهات المعنية؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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
