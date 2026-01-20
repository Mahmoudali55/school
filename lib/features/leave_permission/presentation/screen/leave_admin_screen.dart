import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

import '../../../../core/utils/app_local_kay.dart';
import '../../data/model/leave_model.dart';
import '../cubit/leave_cubit.dart';
import '../cubit/leave_state.dart';

class LeaveAdminScreen extends StatelessWidget {
  const LeaveAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.leave_requests.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          if (state is LeaveLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeaveLoaded) {
            return _buildBody(context, state.leaves);
          } else if (state is LeaveError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<LeaveRequest> leaves) {
    if (leaves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist_rtl, size: 80, color: Colors.grey[400]),
            const Gap(16),
            Text(
              AppLocalKay.no_leave_requests.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final request = leaves[index];
        return _buildAdminLeaveCard(context, request);
      },
    );
  }

  Widget _buildAdminLeaveCard(BuildContext context, LeaveRequest request) {
    final statusColor = _getStatusColor(request.status, context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.studentName,
                        style: AppTextStyle.appBarStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: ${request.studentId}',
                        style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(request.status, context),
              ],
            ),
            const Divider(height: 24),
            Text(
              '${AppLocalKay.leave_reason.tr()}: ${request.reason}',
              style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today,
                  DateFormat('yyyy-MM-dd').format(request.date),
                  context,
                ),
                const SizedBox(width: 16),
                _buildInfoItem(Icons.access_time, request.startTime, context),
              ],
            ),
            if (request.status == LeaveStatus.pending) ...[
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<LeaveCubit>().updateLeaveStatus(
                        request.id,
                        LeaveStatus.rejected,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.errorColor(context),
                        side: BorderSide(color: AppColor.errorColor(context)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(AppLocalKay.status_rejected.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.read<LeaveCubit>().updateLeaveStatus(
                        request.id,
                        LeaveStatus.approved,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondAppColor(context),
                        foregroundColor: AppColor.whiteColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(AppLocalKay.status_approved.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(LeaveStatus status, BuildContext context) {
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
        ).copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColor.infoColor(context)),
        const SizedBox(width: 6),
        Text(value, style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey)),
      ],
    );
  }

  Color _getStatusColor(LeaveStatus status, BuildContext context) {
    switch (status) {
      case LeaveStatus.pending:
        return AppColor.warningColor(context);
      case LeaveStatus.approved:
        return AppColor.secondAppColor(context);
      case LeaveStatus.rejected:
        return AppColor.errorColor(context);
    }
  }

  String _getStatusText(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return AppLocalKay.status_pending.tr();
      case LeaveStatus.approved:
        return AppLocalKay.status_approved.tr();
      case LeaveStatus.rejected:
        return AppLocalKay.status_rejected.tr();
    }
  }
}
