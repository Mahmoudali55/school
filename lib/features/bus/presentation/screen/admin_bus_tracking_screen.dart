import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_bus_details.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_buses_selector.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_emergency_button.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_main_tracking_card.dart';
import 'package:my_template/features/bus/presentation/screen/widget/admin/admin_quick_overview.dart';
import 'package:my_template/features/home/data/models/bus_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminBusTrackingScreen extends StatefulWidget {
  const AdminBusTrackingScreen({super.key});

  @override
  State<AdminBusTrackingScreen> createState() => _AdminBusTrackingScreenState();
}

class _AdminBusTrackingScreenState extends State<AdminBusTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _busAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Fetch real bus data on init
    context.read<HomeCubit>().getData();
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
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.busDataStatus.data != current.busDataStatus.data &&
          current.busDataStatus.isSuccess,
      listener: (context, homeState) {
        if (homeState.busDataStatus.isSuccess) {
          context.read<BusCubit>().updateAdminBuses(homeState.busDataStatus.data ?? []);
        }
      },
      child: BlocBuilder<BusCubit, BusState>(
        builder: (context, busState) {
          final buses = busState.buses;
          final selectedBusData = busState.selectedAdminBus;

          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final busStatus = homeState.busDataStatus;

              if (busStatus.isLoading) {
                return Scaffold(
                  backgroundColor: AppColor.whiteColor(context),
                  body: const Center(child: CustomLoading()),
                );
              }

              if (busStatus.isFailure && buses.isEmpty) {
                return Scaffold(
                  body: Center(child: Text(busStatus.error ?? "Error loading buses")),
                );
              }

              if (buses.isEmpty) {
                return Scaffold(body: Center(child: Text(AppLocalKay.no_buses.tr())));
              }

              // The selectedBusData is now synced via BusCubit
              final displaySelectedBus = selectedBusData ?? buses.first;

              return Scaffold(
                backgroundColor: AppColor.whiteColor(context),
                body: SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              AppLocalKay.bus_title.tr(),
                              style: AppTextStyle.titleLarge(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: AdminBusesSelector(
                          selectedBus: displaySelectedBus.busCode.toString(),
                          buses: buses,
                          onBusSelected: (busNumber) {
                            context.read<BusCubit>().selectAdminBus(busNumber);
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(child: AdminQuickOverview()),
                      SliverToBoxAdapter(
                        child: AdminMainTrackingCard(
                          selectedBusData: displaySelectedBus,
                          busAnimation: _busAnimation,
                          onCallDriver: () => _callDriver(displaySelectedBus),
                          onRefreshLocation: () => _refreshLocation(displaySelectedBus),
                          onSendAlert: () => _sendAlert(displaySelectedBus),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: AdminBusDetails(selectedBusData: displaySelectedBus),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: AdminEmergencyButton(onPressed: _showEmergencyDialog),
              );
            },
          );
        },
      ),
    );
  }

  // Action Methods
  void _callDriver(BusDataModel busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.call_driver.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text('${AppLocalKay.ConnectDriverHint.tr()} ${busData.driverNameAr}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: busData.driverMobile ?? "");
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cannot make a call')));
              }

              Navigator.pop(context);
            },
            child: Text(AppLocalKay.Connect.tr()),
          ),
        ],
      ),
    );
  }

  void _refreshLocation(BusDataModel busData) {
    CommonMethods.showToast(message: AppLocalKay.update_location.tr(), type: ToastType.success);
  }

  void _sendAlert(BusDataModel busData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.send_alert.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text(
          '${AppLocalKay.driver_name.tr().replaceAll('{{name}}', busData.driverNameAr ?? "-")}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CommonMethods.showToast(
                message: AppLocalKay.alert_sent.tr(),
                type: ToastType.success,
              );
            },
            child: Text(AppLocalKay.send.tr()),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.emergency_all_buses.tr()),
        content: Text(AppLocalKay.emergency_content.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalKay.cancel.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CommonMethods.showToast(
                message: AppLocalKay.general_alert_sent.tr(),
                type: ToastType.success,
              );
            },
            child: Text(AppLocalKay.emergency_send_all.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.errorColor(context, listen: false),
            ),
          ),
        ],
      ),
    );
  }
}
