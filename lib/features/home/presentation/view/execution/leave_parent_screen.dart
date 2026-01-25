import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/add_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_request_model.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

import '../../../../../core/utils/app_local_kay.dart';

class LeaveParentScreen extends StatefulWidget {
  final String studentId;
  const LeaveParentScreen({super.key, required this.studentId});

  @override
  State<LeaveParentScreen> createState() => _LeaveParentScreenState();
}

class _LeaveParentScreenState extends State<LeaveParentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPermissions(code: int.parse(HiveMethods.getUserCode()));
  }

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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.getPermissionsStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.getPermissionsStatus.isSuccess) {
            return _buildBody(context, state.getPermissionsStatus.data?.data ?? []);
          } else if (state.getPermissionsStatus.isFailure) {
            return Center(child: Text(state.getPermissionsStatus.error ?? ''));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestLeaveDialog(
          context,
          int.parse(widget.studentId),
          int.parse(HiveMethods.getUserCode()),
        ),
        label: Text(AppLocalKay.request_leave.tr()),
        icon: const Icon(Icons.add),
        backgroundColor: AppColor.infoColor(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<PermissionItem> leaves) {
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

  Widget _buildLeaveCard(BuildContext context, PermissionItem request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                        style: AppTextStyle.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor(context),
                        ),
                      ),
                      const Gap(4),
                      Text(request.reason, style: AppTextStyle.bodyMedium(context)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showRequestLeaveDialog(
                      context,
                      request.studentCode,
                      request.parentCode,
                      permissionItem: request,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.warningColor(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.warningColor(context)),
                    ),
                    child: Text(
                      AppLocalKay.edit.tr(),
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.warningColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (request.notes.isNotEmpty) ...[
              const Gap(8),
              Text(
                request.notes,
                style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
              ),
            ],
            _buildDetailRow(Icons.calendar_month, "تاريخ الطلب", request.requestDate, context),
            const Divider(),
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

  void _showRequestLeaveDialog(
    BuildContext context,
    int studentCode,
    int parentCode, {
    PermissionItem? permissionItem,
  }) {
    final reasonController = TextEditingController(text: permissionItem?.reason);
    final notesController = TextEditingController(text: permissionItem?.notes);
    DateTime selectedDate = DateTime.now();
    if (permissionItem != null) {
      try {
        selectedDate = DateFormat('dd/MM/yyyy').parse(permissionItem.requestDate);
      } catch (e) {
        try {
          selectedDate = DateFormat('yyyy-MM-dd').parse(permissionItem.requestDate);
        } catch (e) {}
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (dialogContext) {
        final homeCubit = context.read<HomeCubit>();
        final initialStudents = homeCubit.state.parentsStudentStatus.data ?? [];
        String currentSelectedStudentId =
            permissionItem?.studentCode.toString() ?? studentCode.toString();
        // Stable GlobalKey inside the builder
        final formKey = GlobalKey<FormState>();

        return BlocProvider.value(
          value: homeCubit,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return BlocListener<HomeCubit, HomeState>(
                listener: (context, state) {
                  final isAddSuccess = state.addPermissionsStatus.isSuccess;
                  final isEditSuccess = state.editPermissionsStatus.isSuccess;

                  if (isAddSuccess || isEditSuccess) {
                    final message = isAddSuccess
                        ? state.addPermissionsStatus.data?.msg
                        : state.editPermissionsStatus.data?.msg;

                    CommonMethods.showToast(message: message ?? "", type: ToastType.success);

                    // 1. Reset status in cubit to prevent re-triggering this listener
                    if (isAddSuccess) {
                      homeCubit.resetAddPermissionStatus();
                    } else {
                      homeCubit.resetEditPermissionStatus();
                    }

                    // 2. Close dialogue immediately
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    // 3. Refresh data after the UI has settled
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      homeCubit.getPermissions(code: int.parse(HiveMethods.getUserCode()));
                    });
                  }
                },
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final students = state.parentsStudentStatus.data ?? initialStudents;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
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
                                permissionItem == null
                                    ? AppLocalKay.new_leave_request.tr()
                                    : AppLocalKay.edit.tr(),
                                style: AppTextStyle.bodyLarge(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              if (students.isNotEmpty) ...[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    AppLocalKay.select_student.tr(),
                                    style: AppTextStyle.bodyMedium(
                                      context,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: currentSelectedStudentId,
                                      isExpanded: true,
                                      items: students.map((student) {
                                        return DropdownMenuItem<String>(
                                          value: student.studentCode.toString(),
                                          child: Text(student.studentName),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setDialogState(() => currentSelectedStudentId = value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              CustomFormField(
                                controller: reasonController,
                                title: AppLocalKay.leave_reason.tr(),
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalKay.please_enter_leave_reason.tr();
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomFormField(
                                controller: notesController,
                                title: AppLocalKay.note.tr(),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalKay.please_enter_note.tr();
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate),
                                  ),
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
                                      setDialogState(() => selectedDate = pickedDate);
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
                                    child: CustomButton(
                                      radius: 12,
                                      cubitState: permissionItem == null
                                          ? state.addPermissionsStatus
                                          : state.editPermissionsStatus,
                                      onPressed: () {
                                        if (reasonController.text.isNotEmpty) {
                                          final hCubit = context.read<HomeCubit>();
                                          final requestDateString = DateFormat(
                                            'yyyy-MM-dd',
                                            'en_US',
                                          ).format(selectedDate);
                                          if (formKey.currentState!.validate()) {
                                            if (permissionItem == null) {
                                              hCubit.addPermissions(
                                                AddPermissionsMobile(
                                                  reason: reasonController.text,
                                                  requestDate: requestDateString,
                                                  studentCode: int.parse(currentSelectedStudentId),
                                                  parentCode: parentCode,
                                                  notes: notesController.text,
                                                ),
                                              );
                                            } else {
                                              hCubit.editPermissions(
                                                EditPermissionsMobileRequest(
                                                  id: permissionItem.id,
                                                  reason: reasonController.text,
                                                  requestDate: requestDateString,
                                                  studentCode: int.parse(currentSelectedStudentId),
                                                  parentCode: parentCode,
                                                  notes: notesController.text,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      text: AppLocalKay.submit_request.tr(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
