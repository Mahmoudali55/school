import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:table_calendar/table_calendar.dart';

import 'attendance_sheet_widgets/attendance_calendar.dart';
import 'attendance_sheet_widgets/attendance_dialogs.dart';
import 'attendance_sheet_widgets/attendance_header.dart';
import 'attendance_sheet_widgets/attendance_list.dart';
import 'attendance_sheet_widgets/attendance_states.dart';

class AttendanceSheet extends StatefulWidget {
  final ClassInfo classInfo;

  const AttendanceSheet({super.key, required this.classInfo});

  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchAttendance(_selectedDay!);
  }

  void _fetchAttendance(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd', 'en').format(date);
    context.read<ClassCubit>().classAbsent(
      classCode: int.tryParse(widget.classInfo.id) ?? 0,
      HWDATE: dateStr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: BlocListener<ClassCubit, ClassState>(
        listenWhen: (previous, current) =>
            previous.editClassAbsentStatus != current.editClassAbsentStatus ||
            previous.deleteHomeworkStatus != current.deleteHomeworkStatus ||
            previous.deleteStudentAbsentStatus != current.deleteStudentAbsentStatus,
        listener: (context, state) {
          if (state.editClassAbsentStatus.isSuccess) {
            CommonMethods.showToast(message: state.editClassAbsentStatus.data?.msg ?? "");
            _fetchAttendance(_selectedDay!);
          }
          if (state.editClassAbsentStatus.isFailure) {
            CommonMethods.showToast(
              message: state.editClassAbsentStatus.error ?? "",
              backgroundColor: AppColor.errorColor(context, listen: false),
            );
          }

          if (state.deleteStudentAbsentStatus.isSuccess) {
            CommonMethods.showToast(message: state.deleteStudentAbsentStatus.data?.errorMsg ?? "");
            _fetchAttendance(_selectedDay!);
          }
          if (state.deleteStudentAbsentStatus.isFailure) {
            CommonMethods.showToast(
              message: state.deleteStudentAbsentStatus.error ?? "",
              backgroundColor: AppColor.errorColor(context, listen: false),
            );
          }

          if (state.deleteHomeworkStatus.isSuccess) {
            CommonMethods.showToast(message: state.deleteHomeworkStatus.data?.errorMsg ?? "");
            _fetchAttendance(_selectedDay!);
          }
          if (state.deleteHomeworkStatus.isFailure) {
            CommonMethods.showToast(
              message: state.deleteHomeworkStatus.error ?? "",
              backgroundColor: AppColor.errorColor(context, listen: false),
            );
          }
        },
        child: Column(
          children: [
            Gap(12.h),
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColor.grey300Color(context).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Gap(24.h),
            AttendanceHeader(classInfo: widget.classInfo),
            Gap(24.h),
            AttendanceCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchAttendance(selectedDay);
                }
              },
            ),
            Gap(16.h),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.surfaceColor(context),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor(context).withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: BlocBuilder<ClassCubit, ClassState>(
                  builder: (context, state) {
                    if (state.classAbsentStatus.isLoading) {
                      return const AttendanceLoadingState();
                    } else if (state.classAbsentStatus.isFailure) {
                      return AttendanceErrorState(
                        error: state.classAbsentStatus.error,
                        onRetry: () => _fetchAttendance(_selectedDay!),
                      );
                    } else if (state.classAbsentStatus.isSuccess) {
                      final list = state.classAbsentStatus.data ?? [];
                      if (list.isEmpty) {
                        return const AttendanceEmptyState();
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: AttendanceList(
                              list: list,
                              onEdit: (item) {
                                AttendanceDialogs.showEditDialog(
                                  context: context,
                                  item: item,
                                  classInfo: widget.classInfo,
                                  selectedDay: _selectedDay!,
                                );
                              },
                              onDelete: (item) {
                                AttendanceDialogs.showDeleteConfirmation(
                                  context: context,
                                  item: item,
                                  selectedDay: _selectedDay!,
                                );
                              },
                            ),
                          ),
                          Gap(16.h),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: CustomButton(
                              radius: 12.r,
                              child: state.deleteHomeworkStatus.isLoading
                                  ? CustomLoading(color: AppColor.whiteColor(context))
                                  : Text(
                                      AppLocalKay.delete_all.tr(),
                                      style: AppTextStyle.bodyMedium(
                                        context,
                                        color: AppColor.whiteColor(context),
                                      ),
                                    ),
                              color: AppColor.errorColor(context),
                              onPressed: () => context.read<ClassCubit>().deleteClassAbsent(
                                classCode: int.tryParse(widget.classInfo.id) ?? 0,
                                HWDATE: DateFormat('yyyy-MM-dd', 'en').format(_selectedDay!),
                              ),
                            ),
                          ),
                          Gap(16.h),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
