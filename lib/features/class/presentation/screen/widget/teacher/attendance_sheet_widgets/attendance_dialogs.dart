import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/home/data/models/add_class_absent_request_model.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';

class AttendanceDialogs {
  static void showEditDialog({
    required BuildContext context,
    required dynamic item,
    required ClassInfo classInfo,
    required DateTime selectedDay,
  }) {
    final TextEditingController notesController = TextEditingController(text: item.notes);
    int selectedType = item.absentType;
    final cubit = context.read<ClassCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            title: Text(AppLocalKay.btn_edit.tr(), textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeOption(
                        context: context,
                        label: AppLocalKay.absent.tr(),
                        isSelected: selectedType == 0,
                        color: AppColor.errorColor(context),
                        onTap: () => setDialogState(() => selectedType = 0),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: _buildTypeOption(
                        context: context,
                        label: AppLocalKay.excused.tr(),
                        isSelected: selectedType == 1,
                        color: AppColor.infoColor(context),
                        onTap: () => setDialogState(() => selectedType = 1),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                CustomFormField(
                  controller: notesController,
                  title: AppLocalKay.note.tr(),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalKay.cancel.tr()),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: BlocBuilder<ClassCubit, ClassState>(
                      builder: (context, state) {
                        return CustomButton(
                          onPressed: () {
                            final dateStr = DateFormat('yyyy-MM-dd', 'en').format(selectedDay);
                            cubit.editClassAbsent(
                              request: AddClassAbsentRequestModel(
                                classCode: item.classCode,
                                absentDate: dateStr,
                                classCodes: item.classCodes ?? classInfo.id,
                                stageCode: int.tryParse(HiveMethods.getUserStage().toString()) ?? 0,
                                levelCode: item.levelCode,
                                sectionCode:
                                    int.tryParse(HiveMethods.getUserSection().toString()) ?? 0,
                                notes: notesController.text,
                                classAbsentList: [
                                  ClassAbsentItem(
                                    studentCode: item.studentCode,
                                    absentType: selectedType,
                                    notes: notesController.text,
                                  ),
                                ],
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: state.editClassAbsentStatus.isLoading
                              ? CustomLoading(color: AppColor.whiteColor(context), size: 10.sp)
                              : Text(
                                  AppLocalKay.save.tr(),
                                  style: AppTextStyle.bodyMedium(
                                    context,
                                  ).copyWith(color: AppColor.whiteColor(context)),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTypeOption({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : AppColor.greyColor(context).withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : AppColor.greyColor(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required dynamic item,
    required DateTime selectedDay,
  }) {
    final cubit = context.read<ClassCubit>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: Text(AppLocalKay.are_you_sure.tr()),
          content: Text(AppLocalKay.delete_user_message.tr()),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalKay.cancel.tr()),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      return CustomButton(
                        color: AppColor.errorColor(context),
                        onPressed: () {
                          cubit.deleteStudentAbsent(
                            classCode: item.classCode,
                            HWDATE: DateFormat('yyyy-MM-dd', 'en').format(selectedDay),
                            studentCode: item.studentCode,
                          );
                          Navigator.pop(context);
                        },
                        child: state.deleteStudentAbsentStatus.isLoading
                            ? CustomLoading(color: AppColor.whiteColor(context), size: 10.sp)
                            : Text(
                                AppLocalKay.delete.tr(),
                                style: AppTextStyle.bodyMedium(
                                  context,
                                ).copyWith(color: AppColor.whiteColor(context)),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
