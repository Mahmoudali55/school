import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class UniformBottomSheet extends StatefulWidget {
  const UniformBottomSheet({
    required this.formKey,
    required this.heightController,
    required this.weightController,
    required this.noteController,
    required this.sizeList,
    required this.currentSize,
    required this.currentStudentId,
    required this.item,
    required this.onSizeChanged,
    required this.onStudentChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController noteController;
  final List<String> sizeList;
  final String currentSize;
  final String? currentStudentId;
  final UniformItem? item;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<String> onStudentChanged;
  final void Function(HomeState state) onSubmit;

  @override
  State<UniformBottomSheet> createState() => _UniformBottomSheetState();
}

class _UniformBottomSheetState extends State<UniformBottomSheet> {
  late String _localSize;
  late String? _localStudentId;

  @override
  void initState() {
    super.initState();
    _localSize = widget.currentSize;
    _localStudentId = widget.currentStudentId;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (ctx, state) {
        final students = state.parentsStudentStatus.data ?? [];

        if (_localStudentId == null && students.isNotEmpty) {
          _localStudentId = students[0].studentCode.toString();
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  // Title
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isEdit
                              ? Icons.edit_rounded
                              : Icons.straighten_rounded,
                          color: AppColor.primaryColor(context),
                          size: 22,
                        ),
                        Gap(8.w),
                        Text(
                          isEdit
                              ? AppLocalKay.edit.tr()
                              : AppLocalKay.student_sizes.tr(),
                          style: AppTextStyle.bodyLarge(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(6.h),
                  Center(
                    child: Text(
                      AppLocalKay.measurements_hint.tr(),
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(20.h),

                  // Student dropdown
                  _SheetLabel(AppLocalKay.select_student.tr()),
                  Gap(8.h),
                  _StyledDropdown<String>(
                    value: _localStudentId,
                    enabled: !isEdit,
                    items: students.isEmpty
                        ? [
                            DropdownMenuItem(
                              value: widget.item?.studentCode,
                              child: Text(
                                widget.item?.studentName ?? '...',
                              ),
                            ),
                          ]
                        : students
                            .map(
                              (s) => DropdownMenuItem<String>(
                                value: s.studentCode.toString(),
                                child: Text(s.studentName),
                              ),
                            )
                            .toList(),
                    onChanged: isEdit
                        ? null
                        : (v) {
                            if (v != null) {
                              setState(() => _localStudentId = v);
                              widget.onStudentChanged(v);
                            }
                          },
                  ),
                  Gap(16.h),

                  // Height & Weight side by side
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: widget.heightController,
                          title: AppLocalKay.height.tr(),
                          prefixIcon: const Icon(Icons.height_rounded),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppLocalKay.please_enter_height.tr()
                              : null,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: CustomFormField(
                          controller: widget.weightController,
                          title: AppLocalKay.weight.tr(),
                          prefixIcon:
                              const Icon(Icons.monitor_weight_outlined),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty)
                              ? AppLocalKay.please_enter_weight.tr()
                              : null,
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),

                  // Size chips
                  _SheetLabel(AppLocalKay.typical_size.tr()),
                  Gap(10.h),
                  Wrap(
                    spacing: 8.w,
                    children: widget.sizeList.map((size) {
                      final isSelected = _localSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _localSize = size);
                          widget.onSizeChanged(size);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor(context)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.primaryColor(context)
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: isSelected
                                  ?  AppColor.whiteColor(context)
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Gap(16.h),

                  // Notes
                  CustomFormField(
                    controller: widget.noteController,
                    title: AppLocalKay.note.tr(),
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    maxLines: 2,
                  ),
                  Gap(24.h),

                  // Submit button
                  CustomButton(
                    radius: 14.r,
                    cubitState: isEdit
                        ? state.editUniformStatus
                        : state.addUniformStatus,
                    onPressed: () => widget.onSubmit(state),
                    text: isEdit ? AppLocalKay.edit.tr() : AppLocalKay.save.tr(),
                  ),
                  Gap(8.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.bodyMedium(context).copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[50] : Colors.grey[100],
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