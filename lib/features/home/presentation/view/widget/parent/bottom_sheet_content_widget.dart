import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({
    required this.formKey,
    required this.reasonController,
    required this.notesController,
    required this.selectedDate,
    required this.currentStudentId,
    required this.students,
    required this.isEditing,
    required this.state,
    required this.onDateChanged,
    required this.onStudentChanged,
    required this.onSubmit,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController reasonController;
  final TextEditingController notesController;
  final DateTime selectedDate;
  final String? currentStudentId;
  final List students;
  final bool isEditing;
  final HomeState state;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onStudentChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEditing
                        ? Icons.edit_calendar_rounded
                        : Icons.add_circle_outline_rounded,
                    color: AppColor.infoColor(context),
                    size: 22,
                  ),
                  const Gap(8),
                  Text(
                    isEditing
                        ? AppLocalKay.edit.tr()
                        : AppLocalKay.new_leave_request.tr(),
                    style: AppTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Gap(24),

              // Student dropdown
              if (students.isNotEmpty) ...[
                _SectionLabel(AppLocalKay.select_student.tr()),
                const Gap(8),
                _StyledDropdown<String>(
                  value: currentStudentId,
                  items: students
                      .map(
                        (s) => DropdownMenuItem<String>(
                          value: s.studentCode.toString(),
                          child: Text(s.studentName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onStudentChanged(v);
                  },
                ),
                const Gap(16),
              ],

              // Reason
              CustomFormField(
                controller: reasonController,
                title: AppLocalKay.leave_reason.tr(),
                maxLines: 1,
                validator: (v) => (v == null || v.isEmpty)
                    ? AppLocalKay.please_enter_leave_reason.tr()
                    : null,
              ),
              const Gap(16),

              // Notes
              CustomFormField(
                controller: notesController,
                title: AppLocalKay.note.tr(),
                maxLines: 3,
                validator: (v) => (v == null || v.isEmpty)
                    ? AppLocalKay.please_enter_note.tr()
                    : null,
              ),
              const Gap(16),

              // Date picker tile
              _DatePickerTile(
                selectedDate: selectedDate,
                onDatePicked: onDateChanged,
              ),
              const Gap(24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        AppLocalKay.cancel.tr(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: CustomButton(
                      radius: 14,
                      cubitState: isEditing
                          ? state.editPermissionsStatus
                          : state.addPermissionsStatus,
                      onPressed: onSubmit,
                      text: AppLocalKay.submit_request.tr(),
                    ),
                  ),
                ],
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: AppTextStyle.bodyMedium(context).copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
class _StyledDropdown<T> extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.selectedDate,
    required this.onDatePicked,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDatePicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null) onDatePicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.infoColor(context).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                color: AppColor.infoColor(context),
                size: 18,
              ),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.leave_date.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
                const Gap(2),
                Text(
                  DateFormat('d MMM yyyy', 'en_US').format(selectedDate),
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}