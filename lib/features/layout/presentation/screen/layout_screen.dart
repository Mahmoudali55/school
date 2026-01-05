import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<NavItemData> _navItems = [
      NavItemData(
        label: AppLocalKay.home.tr(),
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        screen: getScreen("home", widget.selectedUserType.id),
      ),
      NavItemData(
        label: AppLocalKay.calendar.tr(),
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        screen: getScreen("calendar", widget.selectedUserType.id),
        showBadge: _showBadge("calendar"),
      ),
      NavItemData(
        label: AppLocalKay.classes.tr(),
        icon: Icons.class_outlined,
        activeIcon: Icons.class_rounded,
        screen: getScreen("classes", widget.selectedUserType.id),
        showBadge: _showBadge("classes"),
      ),
      NavItemData(
        label: AppLocalKay.bus.tr(),
        icon: Icons.directions_bus_outlined,
        activeIcon: Icons.directions_bus_rounded,
        screen: getScreen("bus", widget.selectedUserType.id),
        showBadge: _showBadge("bus"),
      ),
      NavItemData(
        label: AppLocalKay.settings.tr(),
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        screen: getScreen("settings", widget.selectedUserType.id),
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<HomeCubit>()..getHomeData(widget.selectedUserType.id)),
        BlocProvider(
          create: (context) => sl<ClassCubit>()..getClassData(widget.selectedUserType.id),
        ),
        BlocProvider(
          create: (context) => sl<CalendarCubit>()..getCalendarData(widget.selectedUserType.id),
        ),
        BlocProvider(create: (context) => sl<BusCubit>()..getBusData(widget.selectedUserType.id)),
      ],
      child: Scaffold(
        backgroundColor: AppColor.scaffoldColor(context),
        body: _navItems[_currentIndex].screen,
        bottomNavigationBar: BottomNavBar(
          items: _navItems,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedColor: _getSelectedColor(),
        ),
      ),
    );
  }

  bool _showBadge(String tab) {
    return tab == "bus" && widget.selectedUserType.id == 'parent';
  }

  Color _getSelectedColor() {
    final roleId = widget.selectedUserType.id;
    if (roleId == 'student') return const Color(0xFF4CAF50);
    if (roleId == 'parent') return const Color(0xFF2196F3);
    if (roleId == 'teacher') return const Color(0xFFFF9800);
    if (roleId == 'admin') return const Color(0xFF9C27B0);
    return const Color(0xFF2E5BFF);
  }
}
