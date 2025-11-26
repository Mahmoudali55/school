import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/layout/presentation/screen/widget/bottom_nav_bar_screen.dart';
import 'package:my_template/features/layout/presentation/screen/widget/get_screen_widget.dart';
import 'package:my_template/features/layout/presentation/screen/widget/nav_Item_data_widget.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, required this.selectedUserType});
  final UserTypeModel selectedUserType;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;
  late final List<NavItemData> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = [
      NavItemData(
        label: AppLocalKay.home.tr(),
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        screen: getScreen("home", widget.selectedUserType.title),
      ),
      NavItemData(
        label: AppLocalKay.calendar.tr(),
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        screen: getScreen("calendar", widget.selectedUserType.title),
        showBadge: _showBadge("calendar"),
      ),
      NavItemData(
        label: AppLocalKay.classes.tr(),
        icon: Icons.class_outlined,
        activeIcon: Icons.class_rounded,
        screen: getScreen("classes", widget.selectedUserType.title),
        showBadge: _showBadge("classes"),
      ),
      NavItemData(
        label: AppLocalKay.bus.tr(),
        icon: Icons.directions_bus_outlined,
        activeIcon: Icons.directions_bus_rounded,
        screen: getScreen("bus", widget.selectedUserType.title),
        showBadge: _showBadge("bus"),
      ),
      NavItemData(
        label: AppLocalKay.settings.tr(),
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        screen: getScreen("settings", widget.selectedUserType.title),
      ),
    ];
  }

  bool _showBadge(String tab) {
    return tab == "bus" && widget.selectedUserType.title == AppLocalKay.parent.tr();
  }

  Color _getSelectedColor() {
    final role = widget.selectedUserType.title;
    if (role == AppLocalKay.student.tr()) return const Color(0xFF4CAF50);
    if (role == AppLocalKay.parent.tr()) return const Color(0xFF2196F3);
    if (role == AppLocalKay.teacher.tr()) return const Color(0xFFFF9800);
    if (role == AppLocalKay.admin.tr()) return const Color(0xFF9C27B0);
    return const Color(0xFF2E5BFF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: _navItems[_currentIndex].screen,
      bottomNavigationBar: BottomNavBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedColor: _getSelectedColor(),
      ),
    );
  }
}
