import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
              child: Center(
                child: Text("الحافلة المدرسية", style: AppTextStyle.text16SDark(context)),
              ),
            ),
            // Bus Tracking Card
            SliverToBoxAdapter(child: _buildBusTrackingCard()),

            // Route Progress
            SliverToBoxAdapter(child: _buildRouteProgress()),

            // Bus Information
            SliverToBoxAdapter(child: _buildBusInformation()),

            // Schedule Section
            SliverToBoxAdapter(child: _buildScheduleSection()),

            // Safety Features
            SliverToBoxAdapter(child: _buildSafetyFeatures()),
          ],
        ),
      ),

      // Floating Action Button for emergency
      floatingActionButton: _buildEmergencyButton(),
    );
  }

  Widget _buildBusTrackingCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bus Status Header
          _buildBusStatusHeader(),
          SizedBox(height: 20.h),
          // Map Section
          _buildMapSection(),
          SizedBox(height: 20.h),
          // Bus Controls
          _buildBusControls(),
        ],
      ),
    );
  }

  Widget _buildBusStatusHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.directions_bus_rounded, color: const Color(0xFF4CAF50), size: 24.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الحافلة ${_busData['busNumber']}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                _busData['status'],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _busData['estimatedTime'],
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          // Route Line
          Positioned(
            top: 80.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Stops
          ..._buildStopsOnMap(),
          // Animated Bus
          _buildAnimatedBus(),
        ],
      ),
    );
  }

  List<Widget> _buildStopsOnMap() {
    return _stops.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> stop = entry.value;
      double position = (index / (_stops.length - 1)) * (MediaQuery.of(context).size.width - 80.w);

      return Positioned(
        left: 20.w + position,
        top: 70.h,
        child: Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: stop['current']
                    ? const Color(0xFF4CAF50)
                    : stop['passed']
                    ? const Color(0xFF4CAF50).withOpacity(0.5)
                    : const Color(0xFF9CA3AF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              stop['name'],
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAnimatedBus() {
    int currentIndex = _stops.indexWhere((stop) => stop['current'] == true);
    double progress = currentIndex / (_stops.length - 1);
    double position = progress * (MediaQuery.of(context).size.width - 100.w);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      left: 20.w + position,
      top: 60.h,
      child: AnimatedBuilder(
        animation: _busAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _isBusMoving ? _busAnimation.value : 0),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.directions_bus_rounded, color: const Color(0xFF4CAF50), size: 32.w),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBusControls() {
    return Row(
      children: [
        Expanded(
          child: _buildControlButton(
            "تحديث الموقع",
            Icons.refresh_rounded,
            const Color(0xFF2196F3),
            _refreshLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildControlButton(
            _isBusMoving ? "إيقاف الحركة" : "تشغيل الحركة",
            _isBusMoving ? Icons.pause_rounded : Icons.play_arrow_rounded,
            const Color(0xFFFF9800),
            _toggleBusMovement,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildControlButton(
            "اتصال بالسائق",
            Icons.phone_rounded,
            const Color(0xFF4CAF50),
            _callDriver,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18.w),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(fontSize: 10.sp, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteProgress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مسار الرحلة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          ..._buildRouteStops(),
        ],
      ),
    );
  }

  List<Widget> _buildRouteStops() {
    return _stops.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> stop = entry.value;
      bool isLast = index == _stops.length - 1;

      return Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: stop['current']
                        ? const Color(0xFF4CAF50)
                        : stop['passed']
                        ? const Color(0xFF4CAF50).withOpacity(0.5)
                        : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: stop['current']
                      ? Icon(Icons.directions_bus_rounded, size: 12.w, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2.w,
                    height: 40.h,
                    color: stop['passed'] ? const Color(0xFF4CAF50) : const Color(0xFFE5E7EB),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Stop Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop['name'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    stop['time'],
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
                  ),
                  if (stop['current']) ...[
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "المحطة الحالية",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Status Icon
            Icon(
              stop['passed']
                  ? Icons.check_circle_rounded
                  : stop['current']
                  ? Icons.access_time_rounded
                  : Icons.schedule_rounded,
              color: stop['passed']
                  ? const Color(0xFF4CAF50)
                  : stop['current']
                  ? const Color(0xFFFF9800)
                  : const Color(0xFF6B7280),
              size: 20.w,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildBusInformation() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "معلومات الحافلة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.2,
            children: [
              _buildInfoItem("السائق", _busData['driverName'], Icons.person_rounded),
              _buildInfoItem("رقم الهاتف", _busData['driverPhone'], Icons.phone_rounded),
              _buildInfoItem(
                "السعة",
                "${_busData['occupiedSeats']}/${_busData['capacity']}",
                Icons.people_rounded,
              ),
              _buildInfoItem("السرعة", _busData['speed'], Icons.speed_rounded),
              _buildInfoItem("المسافة", _busData['distance'], Icons.place_rounded),
              _buildInfoItem("آخر تحديث", _busData['lastUpdate'], Icons.update_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: const Color(0xFF4CAF50)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الجدول الزمني",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "اليوم",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ..._buildScheduleItems(),
        ],
      ),
    );
  }

  List<Widget> _buildScheduleItems() {
    return _busSchedule
        .map(
          (schedule) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.schedule_rounded, size: 20.w, color: const Color(0xFF4CAF50)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule['period'],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "الذهاب: ${schedule['pickup']} - الوصول: ${schedule['arrival']}",
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "قادم",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF2196F3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildSafetyFeatures() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ميزات السلامة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildSafetyFeature(
                  "تنبيه الوصول",
                  Icons.notifications_active_rounded,
                  const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  "مشاركة الموقع",
                  Icons.share_location_rounded,
                  const Color(0xFF2196F3),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  "الاتصال العاجل",
                  Icons.emergency_rounded,
                  const Color(0xFFF44336),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyFeature(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _handleSafetyFeature(title),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.w, color: color),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return FloatingActionButton(
      onPressed: _showEmergencyDialog,
      backgroundColor: const Color(0xFFF44336),
      foregroundColor: Colors.white,
      child: Icon(Icons.emergency_rounded, size: 24.w),
    );
  }

  // دوال الإجراءات
  void _refreshLocation() {
    setState(() {
      _busData['lastUpdate'] = 'الآن';
      _busData['estimatedTime'] = '5 دقائق';
      _busData['distance'] = '1.0 كم';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديث الموقع'), backgroundColor: const Color(0xFF4CAF50)),
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
        title: Text('اتصال بالسائق'),
        content: Text('هل تريد الاتصال بالسائق ${_busData['driverName']}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال
            },
            child: Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _handleSafetyFeature(String feature) {
    switch (feature) {
      case 'تنبيه الوصول':
        _setArrivalAlert();
        break;
      case 'مشاركة الموقع':
        _shareLocation();
        break;
      case 'الاتصال العاجل':
        _showEmergencyDialog();
        break;
    }
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه الوصول'),
        content: Text('سيتم إشعارك قبل وصول الحافلة بـ 5 دقائق'),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('تم'))],
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم مشاركة موقع الحافلة'), backgroundColor: const Color(0xFF4CAF50)),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency_rounded, color: Colors.red),
            SizedBox(width: 8.w),
            Text('طوارئ'),
          ],
        ),
        content: Text('هل تريد إرسال تنبيه طوارئ؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إرسال تنبيه الطوارئ'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
