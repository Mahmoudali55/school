import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/add_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_request_model.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/bottom_sheet_content_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/leave_card_widget.dart';
import '../../../../../core/utils/app_local_kay.dart';

class LeaveParentScreen extends StatefulWidget {
  final String studentId;

  const LeaveParentScreen({super.key, required this.studentId});

  @override
  State<LeaveParentScreen> createState() => _LeaveParentScreenState();
}

class _LeaveParentScreenState extends State<LeaveParentScreen> {
  late TextEditingController _reasonController;
  late TextEditingController _notesController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  String? _currentSelectedStudentId;
  PermissionItem? _activePermissionItem;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _notesController = TextEditingController();
    _currentSelectedStudentId = widget.studentId;

    final cubit = context.read<HomeCubit>();
    cubit.getPermissions(code: int.parse(HiveMethods.getUserCode()));
    if (cubit.state.parentsStudentStatus.data == null) {
      cubit.parentData(int.parse(HiveMethods.getUserCode()));
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _prepareDialogData(PermissionItem? item) {
    _activePermissionItem = item;
    _reasonController.text = item?.reason ?? '';
    _notesController.text = item?.notes ?? '';
    _currentSelectedStudentId =
        item?.studentCode.toString() ?? widget.studentId;

    if (item != null) {
      try {
        _selectedDate = DateFormat('dd/MM/yyyy').parse(item.requestDate);
      } catch (_) {
        try {
          _selectedDate = DateFormat('yyyy-MM-dd').parse(item.requestDate);
        } catch (_) {
          _selectedDate = DateTime.now();
        }
      }
    } else {
      _selectedDate = DateTime.now();
    }
  }

  String _formatDateDisplay(DateTime date) =>
      DateFormat('d MMM yyyy', 'en_US').format(date);

  String _formatDateApi(DateTime date) =>
      DateFormat('yyyy-MM-dd', 'en_US').format(date);
  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColor.infoColor(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.leave_requests.tr(),
          style: AppTextStyle.bodyLarge(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.getPermissionsStatus.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          if (state.getPermissionsStatus.isSuccess) {
            return _buildBody(
              context,
              state.getPermissionsStatus.data?.data ?? [],
            );
          }
          if (state.getPermissionsStatus.isFailure) {
            return _buildErrorState(
              context,
              state.getPermissionsStatus.error ?? '',
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _buildFab(context),
    );
  }
  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _prepareDialogData(null);
        _showBottomSheet(context);
      },
      backgroundColor: AppColor.infoColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon:  Icon(Icons.add_rounded, color: AppColor.whiteColor(context)),
      label: Text(
        AppLocalKay.request_leave.tr(),
        style:  TextStyle(
          color: AppColor.whiteColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<PermissionItem> leaves) {
    if (leaves.isEmpty) return _buildEmptyState(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: leaves.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) => LeaveCard(
        request: leaves[index],
        onEdit: () {
          _prepareDialogData(leaves[index]);
          _showBottomSheet(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColor.infoColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 44,
              color: AppColor.infoColor(context),
            ),
          ),
          const Gap(20),
          Text(
            AppLocalKay.no_leave_requests.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 60, color: Colors.grey),
          const Gap(12),
          Text(
            error,
            style: AppTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final parentCode = int.parse(HiveMethods.getUserCode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (dialogContext) => BlocProvider.value(
        value: homeCubit,
        child: StatefulBuilder(
          builder: (ctx, setDialogState) => BlocListener<HomeCubit, HomeState>(
            listener: (ctx, state) {
              final isAddOk = state.addPermissionsStatus.isSuccess;
              final isEditOk = state.editPermissionsStatus.isSuccess;

              if (isAddOk || isEditOk) {
                final msg = isAddOk
                    ? state.addPermissionsStatus.data?.msg
                    : state.editPermissionsStatus.data?.msg;

                CommonMethods.showToast(
                  message: msg ?? '',
                  type: ToastType.success,
                );

                isAddOk
                    ? homeCubit.resetAddPermissionStatus()
                    : homeCubit.resetEditPermissionStatus();

                if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  homeCubit.getPermissions(
                    code: int.parse(HiveMethods.getUserCode()),
                  );
                });
              }
            },
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (ctx, state) {
                final students = state.parentsStudentStatus.data ?? [];
                return BottomSheetContent(
                  formKey: _formKey,
                  reasonController: _reasonController,
                  notesController: _notesController,
                  selectedDate: _selectedDate,
                  currentStudentId: _currentSelectedStudentId,
                  students: students,
                  isEditing: _activePermissionItem != null,
                  state: state,
                  onDateChanged: (d) =>
                      setDialogState(() => _selectedDate = d),
                  onStudentChanged: (v) =>
                      setDialogState(() => _currentSelectedStudentId = v),
                  onSubmit: () {
                    if (!_formKey.currentState!.validate()) return;
                    final dateStr = _formatDateApi(_selectedDate);

                    if (_activePermissionItem == null) {
                      homeCubit.addPermissions(
                        AddPermissionsMobile(
                          reason: _reasonController.text,
                          requestDate: dateStr,
                          studentCode: int.parse(_currentSelectedStudentId!),
                          parentCode: parentCode,
                          notes: _notesController.text,
                        ),
                      );
                    } else {
                      homeCubit.editPermissions(
                        EditPermissionsMobileRequest(
                          id: _activePermissionItem!.id,
                          reason: _reasonController.text,
                          requestDate: dateStr,
                          studentCode: int.parse(_currentSelectedStudentId!),
                          parentCode: parentCode,
                          notes: _notesController.text,
                        ),
                      );
                    }
                  },
                  onCancel: () => Navigator.pop(ctx),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


