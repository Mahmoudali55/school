import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../data/model/pickup_model.dart';
import '../cubit/pickup_cubit.dart';
import '../cubit/pickup_state.dart';

class PickUpAdminScreen extends StatelessWidget {
  const PickUpAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.pick_up_requests.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PickUpCubit, PickUpState>(
        builder: (context, state) {
          if (state is PickUpLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PickUpLoaded) {
            return _buildRequestsList(context, state.requests);
          } else if (state is PickUpError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, List<PickUpRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_pin_circle_outlined, size: 80, color: AppColor.grey600Color(context)),
            const Gap(16),
            Text(
              "No active pick-up requests",
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.hintColor(context), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(context, request);
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, PickUpRequest request) {
    final statusColor = _getStatusColor(request.status, context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Icon(Icons.person, color: statusColor),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.studentName,
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        request.studentGrade,
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.hintColor(context)),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, request.status),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('HH:mm').format(request.requestTime),
                  style: AppTextStyle.labelSmall(
                    context,
                  ).copyWith(color: AppColor.hintColor(context)),
                ),
                if (request.status != PickUpStatus.pickedUp) _buildActionBar(context, request),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, PickUpStatus status) {
    final color = _getStatusColor(status, context);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: AppTextStyle.bodySmall(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, PickUpRequest request) {
    if (request.status == PickUpStatus.pending) {
      return ElevatedButton(
        onPressed: () =>
            context.read<PickUpCubit>().updatePickUpStatus(request.id, PickUpStatus.preparing),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondAppColor(context),
          foregroundColor: AppColor.whiteColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(AppLocalKay.prepare_student.tr()),
      );
    } else if (request.status == PickUpStatus.preparing) {
      return ElevatedButton(
        onPressed: () =>
            context.read<PickUpCubit>().updatePickUpStatus(request.id, PickUpStatus.ready),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondAppColor(context),
          foregroundColor: AppColor.whiteColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(AppLocalKay.status_ready.tr()),
      );
    } else if (request.status == PickUpStatus.ready) {
      return ElevatedButton(
        onPressed: () =>
            context.read<PickUpCubit>().updatePickUpStatus(request.id, PickUpStatus.pickedUp),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.grey100Color(context),
          foregroundColor: AppColor.whiteColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(AppLocalKay.status_picked_up.tr()),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(PickUpStatus status, BuildContext context) {
    switch (status) {
      case PickUpStatus.pending:
        return AppColor.warningColor(context);
      case PickUpStatus.preparing:
        return AppColor.infoColor(context);
      case PickUpStatus.ready:
        return AppColor.secondAppColor(context);
      case PickUpStatus.pickedUp:
        return AppColor.grey400Color(context);
    }
  }

  String _getStatusText(PickUpStatus status) {
    switch (status) {
      case PickUpStatus.pending:
        return AppLocalKay.status_pending.tr();
      case PickUpStatus.preparing:
        return AppLocalKay.status_preparing.tr();
      case PickUpStatus.ready:
        return AppLocalKay.status_ready.tr();
      case PickUpStatus.pickedUp:
        return AppLocalKay.status_picked_up.tr();
    }
  }
}
