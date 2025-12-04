import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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

  Map<String, dynamic> _busData = {};
  List<Map<String, dynamic>> _stops = [];
  List<Map<String, dynamic>> _busSchedule = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
  }

  void _initializeData() {
    _busData = {
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
    };

    _stops = [
      {'name': 'المنزل', 'time': '6:30 ص', 'passed': true, 'current': false},
      {'name': 'شارع التحلية', 'time': '6:45 ص', 'passed': true, 'current': false},
      {'name': 'ميدان الملكة', 'time': '7:00 ص', 'passed': false, 'current': true},
      {'name': 'محطة الجامعة', 'time': '7:15 ص', 'passed': false, 'current': false},
      {'name': 'المدرسة', 'time': '7:30 ص', 'passed': false, 'current': false},
    ];

    _busSchedule = [
      {'period': 'الصباح', 'pickup': '6:30 ص', 'arrival': '7:30 ص'},
      {'period': 'الظهيرة', 'pickup': '12:30 م', 'arrival': '1:30 م'},
      {'period': 'المساء', 'pickup': '3:30 م', 'arrival': '4:30 م'},
    ];
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
    setState(() {
      _busData['lastUpdate'] = 'الآن';
      _busData['estimatedTime'] = '5 دقائق';
      _busData['distance'] = '1.0 كم';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث الموقع'), backgroundColor: Color(0xFF4CAF50)),
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

  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالسائق'),
        content: Text('هل تريد الاتصال بالسائق ${_busData['driverName']}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('اتصال')),
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
        title: const Text('تنبيه الوصول'),
        content: const Text('سيتم إشعارك قبل وصول الحافلة بـ 5 دقائق'),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('تم'))],
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم مشاركة موقع الحافلة'), backgroundColor: Color(0xFF4CAF50)),
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
            const Text('طوارئ'),
          ],
        ),
        content: const Text('هل تريد إرسال تنبيه طوارئ؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال تنبيه الطوارئ'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  // =========================== Build ===========================
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
                  style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BusTrackingCard(
                busData: _busData,
                stops: _stops,
                busAnimation: _busAnimation,
                isBusMoving: _isBusMoving,
                refreshLocation: _refreshLocation,
                toggleBusMovement: _toggleBusMovement,
                callDriver: _callDriver,
              ),
            ),
            SliverToBoxAdapter(child: RouteProgress(stops: _stops)),
            SliverToBoxAdapter(child: BusInformation(busData: _busData)),
            SliverToBoxAdapter(child: ScheduleSection(schedule: _busSchedule)),
            SliverToBoxAdapter(child: SafetyFeatures(onFeatureTap: _handleSafetyFeature)),
          ],
        ),
      ),
      floatingActionButton: EmergencyButton(showDialogCallback: _showEmergencyDialog),
    );
  }
}
