import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

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
        'busColor': Color(0xFF4CAF50),
        'routeColor': Color(0xFF4CAF50),
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
        'busColor': Color(0xFF2196F3),
        'routeColor': Color(0xFF2196F3),
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
        'busColor': Color(0xFFFF9800),
        'routeColor': Color(0xFFFF9800),
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
        'busColor': Color(0xFF9C27B0),
        'routeColor': Color(0xFF9C27B0),
      },
    ];

    _selectedBusData = _allBusesData.first;
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
            SliverToBoxAdapter(child: _buildBusesSelector()),

            // Quick Overview
            SliverToBoxAdapter(child: _buildQuickOverview()),

            // Main Tracking Card
            SliverToBoxAdapter(child: _buildMainTrackingCard()),

            // All Buses Status
            SliverToBoxAdapter(child: _buildAllBusesStatus()),

            // Bus Details
            SliverToBoxAdapter(child: _buildBusDetails()),

            // Fleet Management
            SliverToBoxAdapter(child: _buildFleetManagement()),

            // Safety & Alerts
            SliverToBoxAdapter(child: _buildSafetyAlerts()),
          ],
        ),
      ),

      // Emergency Button
      floatingActionButton: _buildEmergencyButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2), Color(0xFF4A148C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إدارة الحافلات المدرسية",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "لوحة تحكم المدير - متابعة الأسطول",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.whiteColor(context).withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: AppColor.whiteColor(context),
                  size: 24.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "الجمعة، 15 نوفمبر 2024 - 08:30 ص",
            style: TextStyle(fontSize: 14.sp, color: AppColor.whiteColor(context).withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBusesSelector() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_bus_rounded, color: Color(0xFF9C27B0), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.select_bus.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _buses.map((bus) => _buildBusChip(bus)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusChip(String busNumber) {
    final isSelected = _selectedBus == busNumber;
    final busData = _allBusesData.firstWhere((data) => data['busNumber'] == busNumber);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : busData['busColor'],
          ),
          SizedBox(width: 6.w),
          Text(busNumber),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedBus = busNumber;
          _selectedBusData = busData;
        });
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: busData['busColor'],
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? AppColor.whiteColor(context) : Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? busData['busColor'] : Color(0xFFE5E7EB)),
      ),
    );
  }

  Widget _buildQuickOverview() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem(
            "4",
            AppLocalKay.buses.tr(),
            Icons.directions_bus_rounded,
            Color(0xFF10B981),
          ),
          _buildOverviewItem(
            "120",
            AppLocalKay.stats_students.tr(),
            Icons.people_rounded,
            AppColor.primaryColor(context),
          ),
          _buildOverviewItem(
            "94%",
            AppLocalKay.checkin.tr(),
            Icons.percent_rounded,
            AppColor.accentColor(context),
          ),
          _buildOverviewItem(
            "3/4",
            AppLocalKay.user_management_active.tr(),
            Icons.check_circle_rounded,
            Color(0xFFEC4899),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor(context),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildMainTrackingCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bus & Driver Header
          _buildBusHeader(),
          SizedBox(height: 20.h),
          // Map Section
          _buildMapSection(),
          SizedBox(height: 20.h),
          // Quick Actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildBusHeader() {
    Color statusColor;
    IconData statusIcon;

    switch (_selectedBusData['status']) {
      case 'في الطريق':
        statusColor = Color(0xFF4CAF50);
        statusIcon = Icons.directions_bus_rounded;
        break;
      case 'في المحطة':
        statusColor = Color(0xFF2196F3);
        statusIcon = Icons.location_on_rounded;
        break;
      case 'متأخرة':
        statusColor = Color(0xFFFF9800);
        statusIcon = Icons.schedule_rounded;
        break;
      default:
        statusColor = Color(0xFF9E9E9E);
        statusIcon = Icons.directions_bus_rounded;
    }

    return Row(
      children: [
        // Bus Avatar
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: _selectedBusData['busColor'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: _selectedBusData['busColor'],
            size: 24.w,
          ),
        ),
        SizedBox(width: 12.w),
        // Bus Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_selectedBusData['busName']} - ${_selectedBusData['busNumber']}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                "السائق: ${_selectedBusData['driverName']} • ${_selectedBusData['route']}",
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 14.w, color: statusColor),
              SizedBox(width: 4.w),
              Text(
                _selectedBusData['status'],
                style: TextStyle(fontSize: 12.sp, color: statusColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedBusData['busColor'].withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          // Route Line
          Positioned(
            top: 90.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: _selectedBusData['routeColor'].withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // School Icon
          Positioned(
            left: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: Color(0xFF2196F3), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  "المدرسة",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Multiple Stops
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.location_on_rounded, color: Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "المحطة 1",
                  style: TextStyle(fontSize: 8.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.location_on_rounded, color: Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "المحطة 2",
                  style: TextStyle(fontSize: 8.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Animated Bus
          _buildAnimatedBus(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBus() {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.45,
      top: 70.h,
      child: AnimatedBuilder(
        animation: _busAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _busAnimation.value),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_bus_rounded,
                color: _selectedBusData['busColor'],
                size: 32.w,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      spacing: 5.w,
      children: [
        Expanded(
          child: _buildActionButton(
            AppLocalKay.call_driver.tr(),
            Icons.phone_rounded,
            AppColor.secondAppColor(context),
            _callDriver,
          ),
        ),

        Expanded(
          child: _buildActionButton(
            AppLocalKay.update_location.tr(),
            Icons.refresh_rounded,
            AppColor.primaryColor(context),
            _refreshLocation,
          ),
        ),

        Expanded(
          child: _buildActionButton(
            AppLocalKay.send_alert.tr(),
            Icons.notifications_rounded,
            AppColor.accentColor(context),
            _sendAlert,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
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

  Widget _buildAllBusesStatus() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
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
                AppLocalKay.all_buses.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFF9C27B0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_allBusesData.length} حافلات",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _allBusesData.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) => _buildBusStatusItem(_allBusesData[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusStatusItem(Map<String, dynamic> busData) {
    Color statusColor;
    switch (busData['status']) {
      case 'في الطريق':
        statusColor = Color(0xFF4CAF50);
        break;
      case 'في المحطة':
        statusColor = Color(0xFF2196F3);
        break;
      case 'متأخرة':
        statusColor = Color(0xFFFF9800);
        break;
      default:
        statusColor = Color(0xFF9E9E9E);
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Bus Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: busData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_bus_rounded, color: busData['busColor'], size: 18.w),
          ),
          SizedBox(width: 8.w),
          // Bus Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${busData['busName']} - ${busData['busNumber']}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${busData['driverName']} • ${busData['currentLocation']}",
                  style: TextStyle(fontSize: 11.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  busData['status'],
                  style: TextStyle(fontSize: 9.sp, color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                busData['estimatedTime'],
                style: TextStyle(fontSize: 10.sp, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusDetails() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.route_details.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.3,
            children: [
              _buildDetailItem(
                AppLocalKay.bus_number.tr(),
                _selectedBusData['busNumber'],
                Icons.directions_bus_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.driver.tr(),
                _selectedBusData['driverName'],
                Icons.person_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.phone.tr(),
                _selectedBusData['driverPhone'],
                Icons.phone_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.current_location.tr(),
                _selectedBusData['currentLocation'],
                Icons.location_on_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.next_stop.tr(),
                _selectedBusData['nextStop'],
                Icons.flag_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.capacity.tr(),
                "${_selectedBusData['occupiedSeats']}/${_selectedBusData['capacity']}",
                Icons.people_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.estimated_time.tr(),
                _selectedBusData['estimatedTime'],
                Icons.schedule_rounded,
              ),
              _buildDetailItem(
                AppLocalKay.distance.tr(),
                _selectedBusData['distance'],
                Icons.space_dashboard_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: _selectedBusData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: _selectedBusData['busColor']),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFleetManagement() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.manage_accounts_rounded, color: Color(0xFF9C27B0), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.buses_section.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1,
            children: [
              _buildManagementItem(
                AppLocalKay.performance_report.tr(),
                "${_selectedBusData['attendanceRate']} حضور",
                Icons.assessment_rounded,
                AppColor.secondAppColor(context),
              ),
              _buildManagementItem(
                AppLocalKay.status.tr(),
                _selectedBusData['maintenanceStatus'],
                Icons.build_rounded,
                AppColor.accentColor(context),
              ),
              _buildManagementItem(
                AppLocalKay.fuel_level.tr(),
                _selectedBusData['fuelLevel'],
                Icons.local_gas_station_rounded,
                AppColor.primaryColor(context),
              ),
              _buildManagementItem(
                AppLocalKay.passengers_on_board.tr(),
                _selectedBusData['studentsOnBoard'],
                Icons.people_alt_rounded,
                Color(0xFF9C27B0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(icon, size: 16.w, color: color),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyAlerts() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_rounded, color: Color(0xFF2196F3), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.emergency_management.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.general_alert.tr(),
                  Icons.notifications_active_rounded,
                  AppColor.secondAppColor(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.incident_report.tr(),
                  Icons.report_problem_rounded,
                  AppColor.errorColor(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.safety_alert.tr(),
                  Icons.emergency_rounded,
                  AppColor.accentColor(context),
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
      backgroundColor: Color(0xFF9C27B0),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.emergency_rounded, size: 24.w),
    );
  }

  // دوال الإجراءات
  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اتصال بالسائق'),
        content: Text('هل تريد الاتصال بالسائق ${_selectedBusData['driverName']}؟'),
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

  void _refreshLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تحديث موقع ${_selectedBusData['busName']}'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }

  void _sendAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إرسال تنبيه'),
        content: Text('إرسال تنبيه لسائق ${_selectedBusData['busName']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال التنبيه بنجاح'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: Text('إرسال'),
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
        title: Text('تنبيه عام'),
        content: Text('إرسال تنبيه عام لجميع الحافلات'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال التنبيه العام'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: Text('إرسال للجميع'),
          ),
        ],
      ),
    );
  }

  void _reportAccident() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقرير حادث'),
        content: Text('الإبلاغ عن حادث لحافلة ${_selectedBusData['busName']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الإبلاغ عن الحادث'), backgroundColor: Color(0xFFF44336)),
              );
            },
            child: Text('إبلاغ'),
          ),
        ],
      ),
    );
  }

  void _emergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اتصال طوارئ'),
        content: Text('الاتصال بجهات الطوارئ لحافلة ${_selectedBusData['busName']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال بالطوارئ
            },
            child: Text('اتصال'),
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
            Icon(Icons.emergency_rounded, color: Colors.red),
            SizedBox(width: 8.w),
            Text('طوارئ - جميع الحافلات'),
          ],
        ),
        content: Text('إرسال تنبيه طوارئ لجميع الحافلات والجهات المعنية؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال تنبيه الطوارئ لجميع الحافلات'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('إرسال للجميع'),
          ),
        ],
      ),
    );
  }
}
