import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_automatic_call_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class PickUpAdminScreen extends StatefulWidget {
  const PickUpAdminScreen({super.key});

  @override
  State<PickUpAdminScreen> createState() => _PickUpAdminScreenState();
}

class _PickUpAdminScreenState extends State<PickUpAdminScreen> with TickerProviderStateMixin {
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _refreshData();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final stageRaw = HiveMethods.getUserStage();
    final int stageCode = int.tryParse(stageRaw.toString()) ?? 0;
    context.read<HomeCubit>().getAutomaticCallStatus(stageCode: stageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.pick_up_requests.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
            color: AppColor.primaryColor(context),
          ),
        ),

        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withOpacity(0.08),
                blurRadius: 12,  
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Ambient glow background
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryColor(context).withOpacity(0.04),
              ),
            ),
          ),
          BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state.getAutomaticCallStatus?.isSuccess == true) {
                _listController.forward(from: 0);
              }
            },
            builder: (context, state) {
              final status = state.getAutomaticCallStatus;
              if (status?.isLoading == true) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (status?.isSuccess == true) {
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _refreshData();
                  },
                  displacement: kToolbarHeight + 60,
                  child: _buildRequestsList(context, status?.data?.data ?? []),
                );
              } else if (status?.isFailure == true) {
                return Center(child: _buildErrorState(status?.error ?? "Error loading requests"));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off_rounded,
          color: AppColor.errorColor(context).withOpacity(0.3),
          size: 100,
        ),
        const Gap(24),
        Text(
          "Connection Lost",
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.w800),
        ),
        const Gap(8),
        Text(
          message,
          style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.hintColor(context)),
        ),
        const Gap(32),
        ElevatedButton(
          onPressed: _refreshData,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor(context),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("Retry Connection", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildRequestsList(BuildContext context, List<AutomaticCallItem> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 60, 20, 100),
      itemCount: requests.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _listController,
          builder: (context, child) {
            final double slowIndex = index * 0.1;
            final double animValue = Curves.elasticOut.transform(
              (_listController.value - slowIndex).clamp(0, 1),
            );

            return Opacity(
              opacity: (animValue * 1.5).clamp(0, 1),
              child: Transform.translate(offset: Offset(0, 60 * (1 - animValue)), child: child),
            );
          },
          child: _buildRequestCard(context, requests[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 90,
                  color: AppColor.primaryColor(context).withOpacity(0.15),
                ),
              ),
              const Gap(32),
              Text(
                "All Caught Up!",
                style: AppTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: AppColor.primaryColor(context).withOpacity(0.7),
                ),
              ),
              const Gap(12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  "No pending student pick-up requests. Take a deep breath!",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.hintColor(context), height: 1.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(BuildContext context, AutomaticCallItem request) {
    final statusColor = _getStatusColor(request.flag, context);
    final statusText = _getStatusText(request.flag);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
        border: Border.all(color: AppColor.whiteColor(context), width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background soft flair
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Premium Avatar with Ring
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [statusColor.withOpacity(0.08), statusColor.withOpacity(0.02)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(Icons.person_rounded, color: statusColor, size: 36),
                      ),
                    ),
                    const Gap(18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.studentname,
                            style: AppTextStyle.titleLarge(context).copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 19,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const Gap(6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.scaffoldColor(context).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.description_rounded,
                                  size: 12,
                                  color: AppColor.hintColor(context),
                                ),
                                const Gap(6),
                                Flexible(
                                  child: Text(
                                    request.notes.isNotEmpty ? request.notes : "No notes found",
                                    style: AppTextStyle.bodySmall(context).copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.hintColor(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildGlowStatus(context, statusColor, statusText),
                  ],
                ),
                const Gap(24),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.scaffoldColor(context).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 18,
                        color: AppColor.primaryColor(context).withOpacity(0.7),
                      ),
                      const Gap(10),
                      Text(
                        _formatDate(request.transdate),
                        style: AppTextStyle.labelLarge(context).copyWith(
                          color: AppColor.primaryColor(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "URGENT",
                        style: AppTextStyle.labelSmall(context).copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                          color: AppColor.hintColor(context).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String transDate) {
    try {
      final DateTime dt = DateTime.parse(transDate);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return transDate;
    }
  }

  Widget _buildGlowStatus(BuildContext context, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Color _getStatusColor(int flag, BuildContext context) {
    switch (flag) {
      case 1:
        return const Color(0xFFFF9F1C);
      case 2:
        return const Color(0xFF2EC4B6);
      case 3:
        return const Color(0xFF20BF55);
      case 4:
        return const Color(0xFFE71D36);
      default:
        return AppColor.primaryColor(context);
    }
  }

  String _getStatusText(int flag) {
    switch (flag) {
      case 1:
        return AppLocalKay.status_pending.tr();
      case 2:
        return AppLocalKay.status_preparing.tr();
      case 3:
        return AppLocalKay.status_ready.tr();
      case 4:
        return AppLocalKay.status_picked_up.tr();
      default:
        return AppLocalKay.status_pending.tr();
    }
  }
}
