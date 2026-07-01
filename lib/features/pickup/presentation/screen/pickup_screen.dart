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
import 'package:my_template/features/pickup/presentation/screen/widget/pick_up_empty_state.dart';
import 'package:my_template/features/pickup/presentation/screen/widget/pick_up_error_state.dart';
import 'package:my_template/features/pickup/presentation/screen/widget/pick_up_request_card.dart';
import 'package:my_template/features/pickup/presentation/screen/widget/pick_up_stats_dashboard.dart';



class PickUpAdminScreen extends StatefulWidget {
  const PickUpAdminScreen({super.key});

  @override
  State<PickUpAdminScreen> createState() => _PickUpAdminScreenState();
}

class _PickUpAdminScreenState extends State<PickUpAdminScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
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
          _BackgroundGlows(),
          BlocBuilder<HomeCubit, HomeState>(
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
                      PickUpStatsDashboard(requests: requests),
                      Expanded(
                        child: _RequestsList(requests: requests),
                      ),
                    ],
                  ),
                );
              } else if (status?.isFailure == true) {
                return Center(
                  child: PickUpErrorState(
                    message: status?.error ?? "Error loading requests",
                    onRetry: _refreshData,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlows extends StatelessWidget {
  const _BackgroundGlows();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
      ],
    );
  }
}

class _RequestsList extends StatelessWidget {
  const _RequestsList({required this.requests});

  final List<AutomaticCallItem> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const PickUpEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 80.h),
      itemCount: requests.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return PickUpRequestCard(request: requests[index]);
      },
    );
  }
}
