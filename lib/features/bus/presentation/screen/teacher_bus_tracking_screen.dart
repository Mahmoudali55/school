import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/quick_action_Item.dart';
import 'package:my_template/features/bus/presentation/execution/connect_driver_screen.dart';
import 'package:my_template/features/bus/presentation/execution/parent_notification_screen.dart';
import 'package:my_template/features/bus/presentation/execution/report_bus_screen.dart';
import 'package:my_template/features/bus/presentation/execution/route_screen.dart';
import 'package:my_template/features/bus/presentation/execution/settings_screen.dart';
import 'package:my_template/features/bus/presentation/execution/take_attendance_screen.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/bus_class_details_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/classes_selector_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/field_trips_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/main_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/quick_overview_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/students_on_bus_widget.dart';

import '../cubit/bus_tracking_cubit.dart';

class TeacherBusTrackingScreen extends StatefulWidget {
  const TeacherBusTrackingScreen({super.key});

  @override
  State<TeacherBusTrackingScreen> createState() => _TeacherBusTrackingScreenState();
}

class _TeacherBusTrackingScreenState extends State<TeacherBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
    return BlocProvider(
      create: (context) => BusTrackingCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFD),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Text(AppLocalKay.bus_title.tr(), style: AppTextStyle.text16SDark(context)),
                ),
              ),
              const SliverToBoxAdapter(child: ClassesSelectorWidget()),
              const SliverToBoxAdapter(child: QuickOverviewWidget()),
              SliverToBoxAdapter(child: MainTrackingCard(busAnimation: _busAnimation)),
              const SliverToBoxAdapter(child: StudentsOnBusWidget()),
              const SliverToBoxAdapter(child: BusClassDetailsWidget()),
              const SliverToBoxAdapter(child: FieldTripsWidget()),
            ],
          ),
        ),
        floatingActionButton: _buildQuickActionButton(context),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickActions(context),
      backgroundColor: const Color(0xFFFF9800),
      foregroundColor: Colors.white,
      child: Icon(Icons.add_rounded, size: 24.w),
    );
  }

  void _showQuickActions(BuildContext context) {
    final actions = [
      QuickActionItem(
        title: AppLocalKay.check_in.tr(),
        icon: Icons.people_alt_rounded,
        page: const TakeAttendanceScreen(),
      ),
      QuickActionItem(
        title: AppLocalKay.ConnectDriver.tr(),
        icon: Icons.phone_rounded,
        page: const ConnectDriverScreen(),
      ),
      QuickActionItem(
        title: AppLocalKay.ParentNotification.tr(),
        icon: Icons.notifications_rounded,
        page: const ParentNotificationScreen(),
      ),
      QuickActionItem(
        title: AppLocalKay.reportS.tr(),
        icon: Icons.assessment_rounded,
        page: const ReportBusScreen(),
      ),
      QuickActionItem(
        title: AppLocalKay.route.tr(),
        icon: Icons.travel_explore_rounded,
        page: const RouteScreen(),
      ),
      QuickActionItem(
        title: AppLocalKay.settings.tr(),
        icon: Icons.settings_rounded,
        page: const BusSettingsPage(),
      ),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalKay.quick_actions.tr(), style: AppTextStyle.bodyMedium(context)),
            SizedBox(height: 20.h),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: actions.map((action) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // اغلق الـ BottomSheet
                    Navigator.push(context, MaterialPageRoute(builder: (_) => action.page));
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(action.icon, color: const Color(0xFFFF9800)),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        action.title,
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
