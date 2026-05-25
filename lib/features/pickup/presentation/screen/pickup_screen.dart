import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      duration: const Duration(milliseconds: 800),
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
            letterSpacing: -0.8,
            color: AppColor.textColor(context),
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.surfaceColor(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor(context).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16.r, color: AppColor.textColor(context)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background soft ambient glows
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryColor(context).withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -100.w,
            child: Container(
              width: 280.w,
              height: 280.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.secondAppColor(context).withValues(alpha: 0.04),
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
                final requests = status?.data?.data ?? [];
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _refreshData();
                  },
                  displacement: kToolbarHeight + 90.h,
                  child: Column(
                    children: [
                      Gap(kToolbarHeight + 60.h),
                      // Dynamic Modern Statistics Summary
                      _buildStatsDashboard(requests),
                      Expanded(
                        child: _buildRequestsList(context, requests),
                      ),
                    ],
                  ),
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

  Widget _buildStatsDashboard(List<AutomaticCallItem> requests) {
    final pendingCount = requests.where((r) => r.flag == 1).length;
    final preparingCount = requests.where((r) => r.flag == 2).length;
    final readyCount = requests.where((r) => r.flag == 3).length;

    return Container(
      height: 95.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildStatCard(
            "الكل",
            requests.length.toString(),
            Icons.group_rounded,
            const Color(0xFF6366F1),
          ),
          _buildStatCard(
            AppLocalKay.status_pending.tr(),
            pendingCount.toString(),
            Icons.hourglass_empty_rounded,
            const Color(0xFFFF9F1C),
          ),
          _buildStatCard(
            AppLocalKay.status_preparing.tr(),
            preparingCount.toString(),
            Icons.sync_rounded,
            const Color(0xFF2EC4B6),
          ),
          _buildStatCard(
            AppLocalKay.status_ready.tr(),
            readyCount.toString(),
            Icons.done_all_rounded,
            const Color(0xFF20BF55),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor(context).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.r, color: color),
              ),
              Text(
                value,
                style: AppTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: AppTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
              color: AppColor.textColor(context).withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
            decoration: BoxDecoration(
              color: AppColor.errorColor(context).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: AppColor.errorColor(context).withValues(alpha: 0.8),
              size: 72.r,
            ),
          ),
          const Gap(24),
          Text(
            AppLocalKay.SERVER_CONNECTION_ERROR.tr(),
            style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.w900),
          ),
          const Gap(8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.hintColor(context)),
          ),
          const Gap(32),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon:  Icon(Icons.refresh_rounded, color: AppColor.whiteColor(context)),
            label: const Text("إعادة المحاولة", style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor(context),
              foregroundColor: AppColor.whiteColor(context),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              elevation: 4,
              shadowColor: AppColor.primaryColor(context).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, List<AutomaticCallItem> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 80.h),
      itemCount: requests.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _listController,
          builder: (context, child) {
            final double slowIndex = index * 0.08;
            final double animValue = Curves.easeOut.transform(
              (_listController.value - slowIndex).clamp(0, 1),
            );

            return Opacity(
              opacity: animValue,
              child: Transform.translate(
                offset: Offset(0, 40 * (1 - animValue)),
                child: child,
              ),
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
          height: MediaQuery.of(context).size.height * 0.65,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 160.r,
                width: 160.r,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  size: 64.r,
                  color: AppColor.primaryColor(context).withValues(alpha: 0.2),
                ),
              ),
              const Gap(24),
              Text(
                AppLocalKay.NO_PENDING_REQUESTS.tr(),
                style: AppTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                  color: AppColor.textColor(context),
                ),
              ),
              const Gap(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Text(
                  AppLocalKay.NO_PENDING_REQUESTS.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.hintColor(context), height: 1.5),
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
    final initials = request.studentname.trim().isNotEmpty
        ? request.studentname.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor(context).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColor.borderColor(context),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left Stripe Color Indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5.w,
              color: statusColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Styled avatar
                    Container(
                      height: 52.r,
                      width: 52.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColor.withValues(alpha: 0.12), statusColor.withValues(alpha: 0.04)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: AppTextStyle.titleMedium(context).copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.studentname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.bodyLarge(context).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                            ),
                          ),
                          Gap(4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: AppColor.scaffoldColor(context),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  size: 11.r,
                                  color: AppColor.textColor(context).withValues(alpha: 0.55),
                                ),
                                Gap(4.w),
                                Text(
                                  "كود الطالب: ${request.studentcode}",
                                  style: AppTextStyle.bodySmall(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.sp,
                                    color: AppColor.textColor(context).withValues(alpha: 0.55),
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
                if (request.notes.isNotEmpty) ...[
                  Gap(12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColor.scaffoldColor(context).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.speaker_notes_outlined,
                          size: 12.r,
                          color: AppColor.textColor(context).withValues(alpha: 0.6),
                        ),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            request.notes,
                            style: AppTextStyle.bodySmall(context).copyWith(
                              height: 1.3,
                              color: AppColor.textColor(context).withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Gap(12.h),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColor.dividerColor(context).withValues(alpha: 0.4),
                ),
                Gap(10.h),
                // Footer
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13.r,
                      color: AppColor.textColor(context).withValues(alpha: 0.4),
                    ),
                    Gap(6.w),
                    Text(
                      _formatDate(request.transdate),
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.textColor(context).withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColor.errorColor(context).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        AppLocalKay.URGENT.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColor.errorColor(context),
                        ),
                      ),
                    ),
                  ],
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Text(
        text,
        style: AppTextStyle.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 9.sp,
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
