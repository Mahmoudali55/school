import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

import '../../../../core/utils/app_local_kay.dart';
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.getPermissionsStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.getPermissionsStatus.isSuccess) {
            return _buildBody(context, state.getPermissionsStatus.data?.data ?? []);
          } else if (state is LeaveError) {
            return Center(child: Text(state.getPermissionsStatus.error ?? ''));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<PermissionItem> leaves) {
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

  Widget _buildAdminLeaveCard(BuildContext context, PermissionItem request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.studentName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(context).withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "#${request.id}",
                    style: TextStyle(
                      color: AppColor.primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Reason
            Text(
              AppLocalKay.leave_reason.tr(),
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(request.reason, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),

            const SizedBox(height: 16),

            /// Date & Notes
            Row(
              children: [
                _infoChip(context, Icons.calendar_today, _formatDate(request.requestDate, context)),
                const SizedBox(width: 12),
                if (request.notes.isNotEmpty)
                  Expanded(child: _infoChip(context, Icons.notes, request.notes)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date, BuildContext context) {
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat.yMMMMd(context.locale.toString()).format(parsed);
    } catch (e) {
      return date;
    }
  }

  Widget _infoChip(BuildContext context, IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.infoColor(context).withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColor.infoColor(context)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
