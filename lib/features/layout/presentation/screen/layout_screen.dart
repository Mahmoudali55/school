import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
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
import 'package:my_template/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, required this.type});
  final String type;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Normalize user type for consistent state and logic
    final cleanType = widget.type.trim();
    String role;
    if (cleanType == '1' || cleanType == 'student') {
      role = 'student';
    } else if (cleanType == '2' || cleanType == 'parent') {
      role = 'parent';
    } else if (cleanType == '3' || cleanType == 'teacher') {
      role = 'teacher';
    } else {
      role = 'admin';
    }

    final List<NavItemData> _navItems = [
      NavItemData(
        label: AppLocalKay.home.tr(),
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        screen: getScreen("home", role),
      ),
      NavItemData(
        label: AppLocalKay.calendar.tr(),
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        screen: getScreen("calendar", role),
        showBadge: _showBadge("calendar", role),
      ),
      NavItemData(
        label: AppLocalKay.classes.tr(),
        icon: Icons.class_outlined,
        activeIcon: Icons.class_rounded,
        screen: getScreen("classes", role),
        showBadge: _showBadge("classes", role),
      ),
      NavItemData(
        label: role == 'teacher' ? AppLocalKay.smart_assistant.tr() : AppLocalKay.bus.tr(),
        icon: role == 'teacher' ? Icons.auto_awesome_outlined : Icons.directions_bus_outlined,
        activeIcon: role == 'teacher' ? Icons.auto_awesome : Icons.directions_bus_rounded,
        screen: getScreen("bus", role),
        showBadge: _showBadge("bus", role),
      ),
      NavItemData(
        label: AppLocalKay.settings.tr(),
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        screen: getScreen("settings", role),
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<HomeCubit>()
                ..getHomeData(role, role == 'parent' ? int.parse(HiveMethods.getUserCode()) : 0),
        ),
        BlocProvider(create: (context) => sl<ClassCubit>()..getClassData(role)),
        BlocProvider(create: (context) => sl<CalendarCubit>()..getCalendarData(role)),
        BlocProvider(
          create: (context) => sl<BusCubit>()
            ..getBusData(
              role,
              code: role == 'parent' ? int.tryParse(HiveMethods.getUserCode()) : null,
            ),
          // Only initialize for parent/teacher/admin roles that need real data
          // Students now use a standalone mockup
          lazy: role == 'student',
        ),
        BlocProvider(create: (context) => sl<NotificationCubit>()..loadNotifications()),
        BlocProvider(create: (context) => sl<SettingsCubit>()..loadSettings()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.scaffoldColor(context),
        body: _navItems[_currentIndex].screen,
        bottomNavigationBar: BottomNavBar(
          items: _navItems,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedColor: _getSelectedColor(role),
        ),
      ),
    );
  }

  bool _showBadge(String tab, String role) {
    return tab == "bus" && role == 'parent';
  }

  Color _getSelectedColor(String role) {
    if (role == 'student') return const Color(0xFF4CAF50);
    if (role == 'parent') return const Color(0xFF2196F3);
    if (role == 'teacher') return const Color(0xFFFF9800);
    if (role == 'admin') return const Color(0xFF9C27B0);
    return const Color(0xFF2E5BFF);
  }
}
