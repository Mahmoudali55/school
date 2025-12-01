import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class TeacherBusTrackingScreen extends StatefulWidget {
  const TeacherBusTrackingScreen({super.key});

  @override
  State<TeacherBusTrackingScreen> createState() => _TeacherBusTrackingScreenState();
}

class _TeacherBusTrackingScreenState extends State<TeacherBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;
  String _selectedClass = "الصف العاشر - أ";
  final List<String> _classes = ["الصف العاشر - أ", "الصف العاشر - ب", "الصف التاسع - أ"];
  Map<String, dynamic> _selectedClassData = {};
  List<Map<String, dynamic>> _classesData = [];
  List<Map<String, dynamic>> _studentsOnBus = [];
  List<Map<String, dynamic>> _fieldTrips = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
  }

  void _initializeData() {
    _classesData = [
      {
        'className': 'الصف العاشر - أ',
        'subject': 'الرياضيات',
        'totalStudents': '35 طالب',
        'studentsOnBus': '12 طالب',
        'busNumber': 'BUS-2024',
        'driverName': 'أحمد محمد',
        'estimatedArrival': '8 دقائق',
        'currentLocation': 'شارع الملك فهد',
        'nextStop': 'المدرسة',
        'status': 'في الطريق',
        'attendanceRate': '94%',
        'classColor': Color(0xFF4CAF50),
        'busColor': Color(0xFF4CAF50),
      },
      {
        'className': 'الصف العاشر - ب',
        'subject': 'الفيزياء',
        'totalStudents': '32 طالب',
        'studentsOnBus': '15 طالب',
        'busNumber': 'BUS-2025',
        'driverName': 'محمد علي',
        'estimatedArrival': '15 دقيقة',
        'currentLocation': 'حي السلام',
        'nextStop': 'المدرسة',
        'status': 'في المحطة',
        'attendanceRate': '89%',
        'classColor': Color(0xFF2196F3),
        'busColor': Color(0xFF2196F3),
      },
      {
        'className': 'الصف التاسع - أ',
        'subject': 'الكيمياء',
        'totalStudents': '28 طالب',
        'studentsOnBus': '10 طالب',
        'busNumber': 'BUS-2026',
        'driverName': 'خالد أحمد',
        'estimatedArrival': '22 دقيقة',
        'currentLocation': 'حي الروضة',
        'nextStop': 'المدرسة',
        'status': 'متأخرة',
        'attendanceRate': '92%',
        'classColor': Color(0xFFFF9800),
        'busColor': Color(0xFFFF9800),
      },
    ];

    _studentsOnBus = [
      {
        'name': 'محمد أحمد',
        'grade': 'العاشر - أ',
        'boardingStop': 'محطة الجامعة',
        'status': 'في الحافلة',
        'attendance': 'حاضر',
        'seatNumber': 'A1',
        'avatarColor': Color(0xFF4CAF50),
      },
      {
        'name': 'فاطمة علي',
        'grade': 'العاشر - أ',
        'boardingStop': 'سوق المدينة',
        'status': 'في الحافلة',
        'attendance': 'حاضر',
        'seatNumber': 'A2',
        'avatarColor': Color(0xFF2196F3),
      },
      {
        'name': 'خالد محمد',
        'grade': 'العاشر - أ',
        'boardingStop': 'حديقة الحيوانات',
        'status': 'في الحافلة',
        'attendance': 'حاضر',
        'seatNumber': 'A3',
        'avatarColor': Color(0xFFFF9800),
      },
      {
        'name': 'سارة عبدالله',
        'grade': 'العاشر - أ',
        'boardingStop': 'المستشفى العام',
        'status': 'في المحطة',
        'attendance': 'متأخر',
        'seatNumber': 'A4',
        'avatarColor': Color(0xFF9C27B0),
      },
      {
        'name': 'عمر حسن',
        'grade': 'العاشر - أ',
        'boardingStop': 'المركز التجاري',
        'status': 'في الطريق',
        'attendance': 'متوقع',
        'seatNumber': 'A5',
        'avatarColor': Color(0xFFF44336),
      },
    ];

    _fieldTrips = [
      {
        'tripName': 'رحلة المتحف العلمي',
        'date': 'الأحد 20 نوفمبر',
        'time': '08:00 ص - 02:00 م',
        'bus': 'BUS-2024',
        'driver': 'أحمد محمد',
        'students': '25 طالب',
        'status': 'مخطط',
        'color': Color(0xFF4CAF50),
      },
      {
        'tripName': 'زيارة حديقة الحيوانات',
        'date': 'الثلاثاء 22 نوفمبر',
        'time': '09:00 ص - 01:00 م',
        'bus': 'BUS-2025',
        'driver': 'محمد علي',
        'students': '30 طالب',
        'status': 'مؤكد',
        'color': Color(0xFF2196F3),
      },
      {
        'tripName': 'جولة في المكتبة العامة',
        'date': 'الخميس 24 نوفمبر',
        'time': '10:00 ص - 12:00 م',
        'bus': 'BUS-2026',
        'driver': 'خالد أحمد',
        'students': '20 طالب',
        'status': 'ملغى',
        'color': Color(0xFFFF9800),
      },
    ];

    _selectedClassData = _classesData.first;
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
            // Classes Selector
            SliverToBoxAdapter(child: _buildClassesSelector()),

            // Quick Overview
            SliverToBoxAdapter(child: _buildQuickOverview()),

            // Main Tracking Card
            SliverToBoxAdapter(child: _buildMainTrackingCard()),

            // Students on Bus
            SliverToBoxAdapter(child: _buildStudentsOnBus()),

            // Bus & Class Details
            SliverToBoxAdapter(child: _buildBusClassDetails()),

            // Field Trips
            SliverToBoxAdapter(child: _buildFieldTrips()),

            // Quick Actions
            SliverToBoxAdapter(child: _buildQuickActions()),
          ],
        ),
      ),

      // Quick Action Button
    );
  }

  Widget _buildClassesSelector() {
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
              Icon(Icons.class_rounded, color: Color(0xFFFF9800), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                "الفصول الدراسية",
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
            children: _classes.map((className) => _buildClassChip(className)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClassChip(String className) {
    final isSelected = _selectedClass == className;
    final classData = _classesData.firstWhere((data) => data['className'] == className);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_rounded,
            size: 16.w,
            color: isSelected ? Colors.white : classData['classColor'],
          ),
          SizedBox(width: 6.w),
          Text(className),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedClass = className;
          _selectedClassData = classData;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: classData['classColor'],
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? Colors.white : Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? classData['classColor'] : Color(0xFFE5E7EB)),
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
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem("3", "الفصول", Icons.class_rounded, Color(0xFF10B981)),
          _buildOverviewItem("37", "الطلاب", Icons.people_rounded, Color(0xFF3B82F6)),
          _buildOverviewItem("8 د", "أقرب وصول", Icons.schedule_rounded, Color(0xFFF59E0B)),
          _buildOverviewItem("94%", "الحضور", Icons.percent_rounded, Color(0xFFEC4899)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // Class & Bus Header
          _buildClassHeader(),
          SizedBox(height: 20.h),
          // Map Section
          _buildMapSection(),
          SizedBox(height: 20.h),
          // Quick Actions
          _buildTrackingActions(),
        ],
      ),
    );
  }

  Widget _buildClassHeader() {
    Color statusColor;
    IconData statusIcon;

    switch (_selectedClassData['status']) {
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
        // Class Avatar
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: _selectedClassData['classColor'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.class_rounded, color: _selectedClassData['classColor'], size: 24.w),
        ),
        SizedBox(width: 12.w),
        // Class Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedClassData['className'],
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                "${_selectedClassData['subject']} • ${_selectedClassData['studentsOnBus']} على الحافلة",
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
                _selectedClassData['status'],
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
        color: Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedClassData['busColor'].withOpacity(0.3)),
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
                color: _selectedClassData['busColor'].withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // School Icon
          Positioned(
            right: 20.w,
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
          // Student Stops
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.person_pin_circle_rounded, color: Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "محطة 1",
                  style: TextStyle(fontSize: 8.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.person_pin_circle_rounded, color: Color(0xFFFF9800), size: 20.w),
                SizedBox(height: 4.h),
                Text(
                  "محطة 2",
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
      left: MediaQuery.of(context).size.width * 0.35,
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_bus_rounded,
                color: _selectedClassData['busColor'],
                size: 32.w,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            "تسجيل الحضور",
            Icons.people_alt_rounded,
            Color(0xFF4CAF50),
            _takeAttendance,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            "اتصال بالسائق",
            Icons.phone_rounded,
            Color(0xFF2196F3),
            _callDriver,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            "إشعار أولياء الأمور",
            Icons.notifications_rounded,
            Color(0xFFFF9800),
            _notifyParents,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(5.w),
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

  Widget _buildStudentsOnBus() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الطلاب على الحافلة",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_studentsOnBus.length} طالب",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFFFF9800),
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
              itemCount: _studentsOnBus.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) => _buildStudentItem(_studentsOnBus[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(Map<String, dynamic> student) {
    Color statusColor;
    IconData statusIcon;

    switch (student['status']) {
      case 'في الحافلة':
        statusColor = Color(0xFF4CAF50);
        statusIcon = Icons.directions_bus_rounded;
        break;
      case 'في المحطة':
        statusColor = Color(0xFF2196F3);
        statusIcon = Icons.location_on_rounded;
        break;
      case 'في الطريق':
        statusColor = Color(0xFFFF9800);
        statusIcon = Icons.directions_walk_rounded;
        break;
      default:
        statusColor = Color(0xFF9E9E9E);
        statusIcon = Icons.person_rounded;
    }

    Color attendanceColor;
    switch (student['attendance']) {
      case 'حاضر':
        attendanceColor = Color(0xFF4CAF50);
        break;
      case 'متأخر':
        attendanceColor = Color(0xFFFF9800);
        break;
      case 'متوقع':
        attendanceColor = Color(0xFF2196F3);
        break;
      default:
        attendanceColor = Color(0xFF9E9E9E);
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
          // Student Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: student['avatarColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: student['avatarColor'], size: 18.w),
          ),
          SizedBox(width: 8.w),
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  student['name'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${student['grade']} • ${student['boardingStop']}",
                  style: TextStyle(fontSize: 11.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status & Attendance
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 10.w, color: statusColor),
                    SizedBox(width: 4.w),
                    Text(
                      student['status'],
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: attendanceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  student['attendance'],
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: attendanceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusClassDetails() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل الفصل والحافلة",
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
              _buildDetailItem("الفصل", _selectedClassData['className'], Icons.class_rounded),
              _buildDetailItem("المادة", _selectedClassData['subject'], Icons.book_rounded),
              _buildDetailItem(
                "الحافلة",
                _selectedClassData['busNumber'],
                Icons.directions_bus_rounded,
              ),
              _buildDetailItem("السائق", _selectedClassData['driverName'], Icons.person_rounded),
              _buildDetailItem(
                "الوقت المتوقع",
                _selectedClassData['estimatedArrival'],
                Icons.schedule_rounded,
              ),
              _buildDetailItem(
                "المحطة التالية",
                _selectedClassData['nextStop'],
                Icons.flag_rounded,
              ),
              _buildDetailItem(
                "الطلاب على الحافلة",
                _selectedClassData['studentsOnBus'],
                Icons.people_rounded,
              ),
              _buildDetailItem(
                "نسبة الحضور",
                _selectedClassData['attendanceRate'],
                Icons.percent_rounded,
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
              color: _selectedClassData['classColor'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: _selectedClassData['classColor']),
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

  Widget _buildFieldTrips() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الرحلات الميدانية",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_fieldTrips.length} رحلات",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(children: _fieldTrips.map((trip) => _buildFieldTripItem(trip)).toList()),
        ],
      ),
    );
  }

  Widget _buildFieldTripItem(Map<String, dynamic> trip) {
    Color statusColor;
    switch (trip['status']) {
      case 'مخطط':
        statusColor = Color(0xFFFF9800);
        break;
      case 'مؤكد':
        statusColor = Color(0xFF4CAF50);
        break;
      case 'ملغى':
        statusColor = Color(0xFFF44336);
        break;
      default:
        statusColor = Color(0xFF9E9E9E);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Trip Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: trip['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.travel_explore_rounded, size: 18.w, color: trip['color']),
          ),
          SizedBox(width: 12.w),
          // Trip Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['tripName'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${trip['date']} • ${trip['time']}",
                  style: TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
                ),
                SizedBox(height: 4.h),
                Text(
                  "الحافلة: ${trip['bus']} • ${trip['students']}",
                  style: TextStyle(fontSize: 11.sp, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trip['status'],
              style: TextStyle(fontSize: 10.sp, color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الإجراءات السريعة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.7,
            children: [
              _buildQuickActionItem("تسجيل حضور", Icons.people_alt_rounded, Color(0xFF4CAF50)),
              _buildQuickActionItem("اتصال بالسائق", Icons.phone_rounded, Color(0xFF2196F3)),
              _buildQuickActionItem(
                "إشعار أولياء الأمور",
                Icons.notifications_rounded,
                Color(0xFFFF9800),
              ),
              _buildQuickActionItem("تقرير الحضور", Icons.assessment_rounded, Color(0xFF9C27B0)),
              _buildQuickActionItem("الرحلات", Icons.travel_explore_rounded, Color(0xFFF44336)),
              _buildQuickActionItem("الإعدادات", Icons.settings_rounded, Color(0xFF607D8B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _handleQuickAction(title),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, size: 24.w, color: color),
            ),
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

  Widget _buildQuickActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickActions,
      backgroundColor: Color(0xFFFF9800),
      foregroundColor: Colors.white,
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }

  // دوال الإجراءات
  void _takeAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الحضور'),
        content: Text('تسجيل حضور طلاب ${_selectedClassData['className']} على الحافلة'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تسجيل الحضور بنجاح'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: Text('تسجيل'),
          ),
        ],
      ),
    );
  }

  void _callDriver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اتصال بالسائق'),
        content: Text('هل تريد الاتصال بالسائق ${_selectedClassData['driverName']}؟'),
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

  void _notifyParents() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إشعار أولياء الأمور'),
        content: Text('إرسال إشعار لأولياء أمور طلاب ${_selectedClassData['className']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال الإشعار بنجاح'),
                  backgroundColor: Color(0xFFFF9800),
                ),
              );
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'تسجيل حضور':
        _takeAttendance();
        break;
      case 'اتصال بالسائق':
        _callDriver();
        break;
      case 'إشعار أولياء الأمور':
        _notifyParents();
        break;
      case 'تقرير الحضور':
        _showAttendanceReport();
        break;
      case 'الرحلات':
        _showFieldTrips();
        break;
      case 'الإعدادات':
        _openSettings();
        break;
    }
  }

  void _showAttendanceReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح تقرير حضور ${_selectedClassData['className']}'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  void _showFieldTrips() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فتح إدارة الرحلات الميدانية'), backgroundColor: Color(0xFFF44336)),
    );
  }

  void _openSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فتح إعدادات المتابعة'), backgroundColor: Color(0xFF607D8B)),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إجراءات سريعة',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionBottomItem('تسجيل حضور', Icons.people_alt_rounded),
                _buildQuickActionBottomItem('اتصال سائق', Icons.phone_rounded),
                _buildQuickActionBottomItem('إشعار أولياء أمور', Icons.notifications_rounded),
                _buildQuickActionBottomItem('تقرير', Icons.assessment_rounded),
                _buildQuickActionBottomItem('رحلات', Icons.travel_explore_rounded),
                _buildQuickActionBottomItem('إعدادات', Icons.settings_rounded),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBottomItem(String title, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Color(0xFFFF9800).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFFFF9800)),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
