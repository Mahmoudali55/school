import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/Bus/presentation/screen/bus_screen.dart';
import 'package:my_template/features/bus/presentation/screen/admin_bus_tracking_screen.dart';
import 'package:my_template/features/bus/presentation/screen/bus_tracking_Screen.dart';
import 'package:my_template/features/bus/presentation/screen/teacher_bus_tracking_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_admin_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_patant_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/calendar_teacher_screen.dart';
import 'package:my_template/features/class/presentation/screen/student_classes_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/admin_home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/parent_home_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/teacher_home_screen.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, required this.selectedUserType});
  final UserTypeModel selectedUserType;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;

  List<Widget> get _tabs => [
    _buildHomeScreen(),
    _buildCalendarScreen(),
    _buildClassScreen(),
    _buildBusScreen(),
    _buildSettingsScreen(),
  ];

  Widget _buildHomeScreen() {
    switch (widget.selectedUserType.title) {
      case 'ولي امر':
        return const HomeParentScreen();
      case 'مدرس':
        return const TeacherHomeScreen();
      case 'مدير':
        return const AdminHomeScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildCalendarScreen() {
    switch (widget.selectedUserType.title) {
      case 'ولي امر':
        return const CalendarPatentScreen();
      case 'مدرس':
        return const CalendarTeacherScreen();
      case 'مدير':
        return const AdminCalendarScreen();
      default:
        return const CalendarScreen();
    }
  }

  Widget _buildClassScreen() {
    switch (widget.selectedUserType.title) {
      case 'ولي امر':
        return const CalendarPatentScreen();
      case 'مدرس':
        return const CalendarTeacherScreen();
      case 'مدير':
        return const AdminCalendarScreen();
      default:
        return const StudentClassesScreen();
    }
  }

  Widget _buildBusScreen() {
    switch (widget.selectedUserType.title) {
      case 'ولي امر':
        return const ParentBusTrackingScreen();
      case 'مدرس':
        return const TeacherBusTrackingScreen();
      case 'مدير':
        return const AdminBusTrackingScreen();
      default:
        return const StudentBusTrackingScreen();
    }
  }

  Widget _buildSettingsScreen() {
    switch (widget.selectedUserType.title) {
      case 'ولي امر':
        return const CalendarPatentScreen();
      case 'مدرس':
        return const CalendarTeacherScreen();
      case 'مدير':
        return const AdminCalendarScreen();
      default:
        return const StudentClassesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),

      body: _tabs[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          selectedItemColor: _getSelectedColor(),
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedFontSize: 11.sp,
          unselectedFontSize: 10.sp,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, height: 1.5),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, height: 1.5),
          elevation: 0,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _buildNavItems(),
        ),
      ),
    );
  }

  Color _getSelectedColor() {
    switch (widget.selectedUserType.title) {
      case 'طالب':
        return const Color(0xFF4CAF50);
      case 'ولي امر':
        return const Color(0xFF2196F3);
      case 'مدرس':
        return const Color(0xFFFF9800);
      case 'مدير':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2E5BFF);
    }
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    bool isParent = widget.selectedUserType.title == 'ولي امر';

    return [
      _buildNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: "الرئيسية",
        badge: false,
      ),
      _buildNavItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        label: "التقويم",
        badge: _hasUpcomingEvents(),
      ),
      _buildNavItem(
        icon: Icons.groups_outlined,
        activeIcon: Icons.groups_rounded,
        label: "الفصول",
        badge: false,
      ),
      _buildNavItem(
        icon: Icons.directions_bus_outlined,
        activeIcon: Icons.directions_bus_rounded,
        label: "الحافلة",
        badge: isParent && _hasBusUpdates(),
      ),
      _buildNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        label: "الإعدادات",
        badge: _hasNewSettings(),
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool badge,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, size: 24.w),
          ),
          if (badge)
            Positioned(
              right: -2.w,
              top: -2.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
      activeIcon: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: _getSelectedColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(activeIcon, size: 24.w, color: _getSelectedColor()),
      ),
      label: label,
    );
  }

  bool _hasUpcomingEvents() {
    return false;
  }

  bool _hasBusUpdates() {
    return true;
  }

  bool _hasNewSettings() {
    return false;
  }
}
