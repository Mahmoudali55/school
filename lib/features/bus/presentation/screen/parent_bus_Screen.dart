import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

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
                child: Text(
                  AppLocalKay.bus_title.tr(),
                  style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
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

  Widget _buildChildrenSelector() {
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
              Icon(
                Icons.family_restroom_rounded,
                color: AppColor.primaryColor(context),
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.select_student.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
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
            color: isSelected ? AppColor.whiteColor(context) : childData['busColor'],
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
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: childData['busColor'],
      labelStyle: AppTextStyle.bodyMedium(context).copyWith(
        color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
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
            color: AppColor.blackColor(context).withOpacity(0.3),
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
            AppLocalKay.children.tr(),
            Icons.family_restroom_rounded,
            AppColor.secondAppColor(context),
          ),
          _buildOverviewItem(
            "2",
            AppLocalKay.in_bus.tr(),
            Icons.directions_bus_rounded,
            AppColor.primaryColor(context),
          ),
          _buildOverviewItem(
            "7 د",
            AppLocalKay.nearest_arrival.tr(),
            Icons.schedule_rounded,
            AppColor.accentColor(context),
          ),
          _buildOverviewItem(
            "٣/٣",
            AppLocalKay.safe.tr(),
            Icons.verified_rounded,
            const Color(0xFFEC4899),
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
          style: AppTextStyle.bodyLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
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
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Text(
                "${_selectedBusData['school']} - ${_selectedBusData['grade']}",
                style: AppTextStyle.bodyMedium(context).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: _selectedBusData['onBoard']
                ? AppColor.secondAppColor(context).withOpacity(0.1)
                : AppColor.accentColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _selectedBusData['onBoard'] ? AppLocalKay.in_bus.tr() : AppLocalKay.waiting.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(
              color: _selectedBusData['onBoard']
                  ? AppColor.secondAppColor(context)
                  : AppColor.accentColor(context),
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
                Icon(Icons.home_rounded, color: AppColor.secondAppColor(context), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  AppLocalKay.home_address.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
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
                Icon(Icons.school_rounded, color: AppColor.primaryColor(context), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  AppLocalKay.school.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
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
                color: AppColor.whiteColor(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.2),
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
            AppLocalKay.call_driver.tr(),
            Icons.phone_rounded,
            AppColor.secondAppColor(context),
            _callDriver,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            AppLocalKay.share_location.tr(),
            Icons.share_rounded,
            AppColor.primaryColor(context),
            _shareLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            AppLocalKay.arrival_alert.tr(),
            Icons.notifications_rounded,
            AppColor.accentColor(context),
            _setArrivalAlert,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18.w),
          SizedBox(height: 10.w),
          Text(
            text,
            style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: color),
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
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
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
                AppLocalKay.all_children.tr(),
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_childrenBusData.length} ${AppLocalKay.children.tr()}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.w600),
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
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${childData['school']} • ${childData['estimatedTime']}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
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
                      ? AppColor.secondAppColor(context).withOpacity(0.1)
                      : AppColor.accentColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  childData['onBoard'] ? AppLocalKay.in_bus.tr() : AppLocalKay.waiting.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 9.sp,
                    color: childData['onBoard']
                        ? AppColor.secondAppColor(context)
                        : AppColor.accentColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                childData['attendance'],
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontSize: 10.sp, color: const Color(0xFF6B7280)),
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
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.route_details.tr(),
            style: AppTextStyle.titleLarge(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: _selectedBusData['busColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: _selectedBusData['busColor']),
          ),
          SizedBox(height: 8.w),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
          ),
          SizedBox(height: 8.w),
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
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_rounded, color: AppColor.primaryColor(context), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.features.tr(),
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.arrival_alert.tr(),
                  Icons.notifications_active_rounded,
                  const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.follow_route.tr(),
                  Icons.travel_explore_rounded,
                  AppColor.primaryColor(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSafetyFeature(
                  AppLocalKay.report_incident.tr(),
                  Icons.report_problem_rounded,
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
        padding: EdgeInsets.all(15.w),
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
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 12.sp, color: color, fontWeight: FontWeight.w600),
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
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.emergency_rounded, size: 24.w),
    );
  }

  // دوال الإجراءات
  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.ConnectDriverHint.tr()}${_selectedBusData['driverName']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال
            },
            child: Text(AppLocalKay.Connect.tr(), style: AppTextStyle.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalKay.share_location.tr()} ${_selectedBusData['childName']}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _setArrivalAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.arrival_alert.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text(
          '${AppLocalKay.alert_message.tr()}${_selectedBusData['childName']} بـ 10 دقائق',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.confirm.tr(), style: AppTextStyle.bodyMedium(context)),
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
        title: Text(AppLocalKay.report_incident.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.select_problem.tr()}${_selectedBusData['childName']}'),
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
