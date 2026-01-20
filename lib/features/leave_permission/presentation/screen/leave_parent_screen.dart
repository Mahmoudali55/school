import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

import '../../../../core/utils/app_local_kay.dart';
import '../../data/model/leave_model.dart';
import '../cubit/leave_cubit.dart';
import '../cubit/leave_state.dart';

class LeaveParentScreen extends StatelessWidget {
  final String studentId;
  const LeaveParentScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.student_leave.tr()),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestLeaveDialog(context),
        label: Text(AppLocalKay.request_leave.tr()),
        icon: const Icon(Icons.add),
        backgroundColor: AppColor.infoColor(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<LeaveRequest> leaves) {
    if (leaves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
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
        return _buildLeaveCard(context, request);
      },
    );
  }

  Widget _buildLeaveCard(BuildContext context, LeaveRequest request) {
    final statusColor = _getStatusColor(request.status, context);
    final statusText = _getStatusText(request.status);

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
                Text(
                  request.reason,
                  style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow(
              Icons.calendar_today,
              AppLocalKay.leave_date.tr(),
              DateFormat('yyyy-MM-dd').format(request.date),
              context,
            ),
            const Gap(8),
            _buildDetailRow(
              Icons.access_time,
              AppLocalKay.start_time.tr(),
              request.startTime,
              context,
            ),
            if (request.endTime != null) ...[
              const Gap(8),
              _buildDetailRow(
                Icons.access_time_filled,
                AppLocalKay.end_time.tr(),
                request.endTime!,
                context,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.infoColor(context)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.w500),
        ),
        Text(value, style: AppTextStyle.bodyMedium(context)),
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

  void _showRequestLeaveDialog(BuildContext context) {
    final reasonController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedStartTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      AppLocalKay.new_leave_request.tr(),
                      style: AppTextStyle.bodyLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      controller: reasonController,
                      title: AppLocalKay.leave_reason.tr(),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                        subtitle: Text(AppLocalKay.leave_date.tr()),
                        leading: const Icon(Icons.calendar_today, color: Colors.blue),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (pickedDate != null) {
                            setState(() => selectedDate = pickedDate);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(selectedStartTime.format(context)),
                        subtitle: Text(AppLocalKay.start_time.tr()),
                        leading: const Icon(Icons.access_time, color: Colors.green),
                        onTap: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedStartTime,
                          );
                          if (pickedTime != null) {
                            setState(() => selectedStartTime = pickedTime);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(AppLocalKay.cancel.tr()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (reasonController.text.isNotEmpty) {
                                final newRequest = LeaveRequest(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  studentId: studentId,
                                  studentName: "Student Name",
                                  studentGrade: "N/A",
                                  reason: reasonController.text,
                                  date: selectedDate,
                                  startTime: selectedStartTime.format(context),
                                  status: LeaveStatus.pending,
                                  createdAt: DateTime.now(),
                                );
                                context.read<LeaveCubit>().placeLeaveRequest(newRequest);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(AppLocalKay.submit_request.tr()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
