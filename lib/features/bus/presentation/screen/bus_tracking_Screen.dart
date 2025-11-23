import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class ParentBusTrackingScreen extends StatefulWidget {
  const ParentBusTrackingScreen({super.key});

  @override
  State<ParentBusTrackingScreen> createState() => _ParentBusTrackingScreenState();
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
            // App Bar
            SliverToBoxAdapter(
              child: Center(
                child: Text("الحافلة المدرسية", style: AppTextStyle.text16SDark(context)),
              ),
            ),
            // Children Selector
            SliverToBoxAdapter(child: _buildChildrenSelector()),

            // Quick Overview
            SliverToBoxAdapter(child: _buildQuickOverview()),

            // Main Tracking Card
            SliverToBoxAdapter(child: _buildMainTrackingCard()),

            // All Children Status
            SliverToBoxAdapter(child: _buildAllChildrenStatus()),

            // Bus Details
            SliverToBoxAdapter(child: _buildBusDetails()),

            // Safety & Alerts
            SliverToBoxAdapter(child: _buildSafetyAlerts()),
          ],
        ),
      ),

      // Emergency Button
      floatingActionButton: _buildEmergencyButton(),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF0D47A1)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "متتبع الحافلات",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "تابع أبنائك في الوقت الفعلي",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenSelector() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(Icons.family_restroom_rounded, color: const Color(0xFF2196F3), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                "اختر الابن للمتابعة",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _children.map((child) => _buildChildChip(child)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildChip(String childName) {
    final isSelected = _selectedChild == childName;
    final childData = _childrenBusData.firstWhere((data) => data['childName'] == childName);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            childData['onBoard'] ? Icons.directions_bus_rounded : Icons.person_rounded,
            size: 16.w,
            color: isSelected ? Colors.white : childData['busColor'],
          ),
          SizedBox(width: 6.w),
          Text(childName),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedChild = childName;
          _selectedBusData = childData;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: childData['busColor'],
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? Colors.white : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? childData['busColor'] : const Color(0xFFE5E7EB)),
      ),
    );
  }

  Widget _buildQuickOverview() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem(
            "3",
            "الأبناء",
            Icons.family_restroom_rounded,
            const Color(0xFF10B981),
          ),
          _buildOverviewItem(
            "2",
            "في الحافلة",
            Icons.directions_bus_rounded,
            const Color(0xFF3B82F6),
          ),
          _buildOverviewItem("7 د", "أقرب وصول", Icons.schedule_rounded, const Color(0xFFF59E0B)),
          _buildOverviewItem("٣/٣", "آمنة", Icons.verified_rounded, const Color(0xFFEC4899)),
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
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMainTrackingCard() {
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
          // Child & Bus Header
          _buildChildHeader(),
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

  Widget _buildChildHeader() {
    return Row(
      children: [
        // Child Avatar
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: _selectedBusData['busColor'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_rounded, color: _selectedBusData['busColor'], size: 24.w),
        ),
        SizedBox(width: 12.w),
        // Child Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedBusData['childName'],
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                "${_selectedBusData['school']} - ${_selectedBusData['grade']}",
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: _selectedBusData['onBoard']
                ? const Color(0xFF10B981).withOpacity(0.1)
                : const Color(0xFFFF9800).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _selectedBusData['onBoard'] ? "في الحافلة" : "في الانتظار",
            style: TextStyle(
              fontSize: 12.sp,
              color: _selectedBusData['onBoard']
                  ? const Color(0xFF10B981)
                  : const Color(0xFFFF9800),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
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
                color: _selectedBusData['busColor'].withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Home Icon
          Positioned(
            left: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.home_rounded, color: const Color(0xFF10B981), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  "المنزل",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // School Icon
          Positioned(
            right: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: const Color(0xFF2196F3), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  "المدرسة",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
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
      left: MediaQuery.of(context).size.width * 0.3,
      top: 70.h,
      child: AnimatedBuilder(
        animation: _busAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _busAnimation.value),
            child: Container(
              padding: EdgeInsets.all(10.w),
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
      children: [
        Expanded(
          child: _buildActionButton(
            "اتصال بالسائق",
            Icons.phone_rounded,
            const Color(0xFF4CAF50),
            _callDriver,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            "مشاركة الموقع",
            Icons.share_rounded,
            const Color(0xFF2196F3),
            _shareLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            "تنبيه الوصول",
            Icons.notifications_rounded,
            const Color(0xFFFF9800),
            _setArrivalAlert,
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

  Widget _buildAllChildrenStatus() {
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
                "حالة جميع الأبناء",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_childrenBusData.length} أبناء",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF2196F3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // الحل: استخدام ListView مع ارتفاع محدد
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 250.h, // ارتفاع مناسب
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _childrenBusData.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) => _buildChildStatusItem(_childrenBusData[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildStatusItem(Map<String, dynamic> childData) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Child Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: childData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: childData['busColor'], size: 18.w),
          ),
          SizedBox(width: 8.w),
          // Child Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  childData['childName'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${childData['school']} • ${childData['estimatedTime']}",
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
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
                  color: childData['onBoard']
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  childData['onBoard'] ? "في الحافلة" : "في الانتظار",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: childData['onBoard'] ? const Color(0xFF10B981) : const Color(0xFFFF9800),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                childData['attendance'],
                style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B7280)),
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
            "تفاصيل الحافلة",
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
            childAspectRatio: 1.5,
            children: [
              _buildDetailItem(
                "رقم الحافلة",
                _selectedBusData['busNumber'],
                Icons.directions_bus_rounded,
              ),
              _buildDetailItem("السائق", _selectedBusData['driverName'], Icons.person_rounded),
              _buildDetailItem("رقم الهاتف", _selectedBusData['driverPhone'], Icons.phone_rounded),
              _buildDetailItem(
                "الموقع",
                _selectedBusData['currentLocation'],
                Icons.location_on_rounded,
              ),
              _buildDetailItem("المحطة التالية", _selectedBusData['nextStop'], Icons.flag_rounded),
              _buildDetailItem(
                "السعة",
                "${_selectedBusData['occupiedSeats']}/${_selectedBusData['capacity']}",
                Icons.people_rounded,
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
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
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

  Widget _buildSafetyAlerts() {
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
            children: [
              Icon(Icons.security_rounded, color: const Color(0xFF2196F3), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                "ميزات السلامة",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
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
                  "متابعة الرحلة",
                  Icons.travel_explore_rounded,
                  const Color(0xFF2196F3),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  "الإبلاغ عن مشكلة",
                  Icons.report_problem_rounded,
                  const Color(0xFFFF9800),
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

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم مشاركة موقع ${_selectedBusData['childName']}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه الوصول'),
        content: Text('سيتم إشعارك قبل وصول ${_selectedBusData['childName']} بـ 10 دقائق'),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('تم'))],
      ),
    );
  }

  void _handleSafetyFeature(String feature) {
    switch (feature) {
      case 'تنبيه الوصول':
        _setArrivalAlert();
        break;
      case 'متابعة الرحلة':
        _showTripHistory();
        break;
      case 'الإبلاغ عن مشكلة':
        _reportProblem();
        break;
    }
  }

  void _showTripHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح سجل رحلات ${_selectedBusData['childName']}'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _reportProblem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإبلاغ عن مشكلة'),
        content: Text('اختر نوع المشكلة التي تواجهها مع حافلة ${_selectedBusData['childName']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم الإبلاغ عن المشكلة'),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            child: Text('إرسال'),
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
            Text('طوارئ'),
          ],
        ),
        content: Text('إرسال تنبيه طوارئ لجميع الجهات المعنية؟'),
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
            child: Text('إرسال للجميع'),
          ),
        ],
      ),
    );
  }
}
