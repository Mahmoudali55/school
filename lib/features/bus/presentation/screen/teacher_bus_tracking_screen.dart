import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/quick_overview_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/bus_class_details_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/classes_selector_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/field_trips_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/teacher/main_tracking_card.dart';
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
              // App Bar
              SliverToBoxAdapter(
                child: Center(
                  child: Text(AppLocalKay.bus_title.tr(), style: AppTextStyle.text16SDark(context)),
                ),
              ),
              // Classes Selector
              const SliverToBoxAdapter(child: ClassesSelectorWidget()),
              // Quick Overview
              const SliverToBoxAdapter(child: QuickOverviewWidget()),
              // Main Tracking Card
              SliverToBoxAdapter(child: MainTrackingCard(busAnimation: _busAnimation)),
              // Students on Bus
              const SliverToBoxAdapter(child: StudentsOnBusWidget()),
              // Bus & Class Details
              const SliverToBoxAdapter(child: BusClassDetailsWidget()),
              // Field Trips
              const SliverToBoxAdapter(child: FieldTripsWidget()),

              // Quick Actions
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
            Text(
              AppLocalKay.quick_actions.tr(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionBottomItem(
                  AppLocalKay.check_in.tr(),
                  Icons.people_alt_rounded,
                  context,
                ),
                _buildQuickActionBottomItem(
                  AppLocalKay.ConnectDriver.tr(),
                  Icons.phone_rounded,
                  context,
                ),
                _buildQuickActionBottomItem(
                  AppLocalKay.ParentNotification.tr(),
                  Icons.notifications_rounded,
                  context,
                ),
                _buildQuickActionBottomItem(
                  AppLocalKay.reportS.tr(),
                  Icons.assessment_rounded,
                  context,
                ),
                _buildQuickActionBottomItem(
                  AppLocalKay.route.tr(),
                  Icons.travel_explore_rounded,
                  context,
                ),
                _buildQuickActionBottomItem(
                  AppLocalKay.settings.tr(),
                  Icons.settings_rounded,
                  context,
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBottomItem(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => _handleQuickAction(title, context),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFF9800)),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action, BuildContext context) {
    final cubit = context.read<BusTrackingCubit>();
    switch (action) {
      case 'تسجيل حضور':
        cubit.takeAttendance();
        Navigator.pop(context);
        break;
      case 'اتصال سائق':
        // TODO: تنفيذ الاتصال
        Navigator.pop(context);
        break;
      case 'إشعار أولياء أمور':
        // TODO: تنفيذ الإشعار
        Navigator.pop(context);
        break;
      default:
        Navigator.pop(context);
    }
  }
}
