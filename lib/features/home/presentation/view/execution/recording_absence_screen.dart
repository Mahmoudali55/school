import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/student_class_data_model.dart';
import 'package:my_template/features/home/data/models/add_class_absent_request_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class RecordingAbsenceScreen extends StatefulWidget {
  const RecordingAbsenceScreen({super.key});

  @override
  State<RecordingAbsenceScreen> createState() => _RecordingAbsenceScreenState();
}

class AbsenceRecord {
  final int type; // 0 = Absent, 1 = Leave
  final String notes;
  AbsenceRecord({required this.type, required this.notes});
}

class _RecordingAbsenceScreenState extends State<RecordingAbsenceScreen> {
  TeacherLevelModel? _selectedLevel;
  TeacherClassModels? _selectedClass;
  final Map<int, AbsenceRecord> _absences = {}; // studentCode -> details

  @override
  void initState() {
    super.initState();
    // Load teacher levels on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
        context.read<HomeCubit>().teacherLevel(stageCode);
      }
    });
  }

  void _onLevelChanged(TeacherLevelModel? level) {
    setState(() {
      _selectedLevel = level;
      _selectedClass = null; // Reset class selection when level changes
      _absences.clear(); // Clear absences when level changes
    });

    if (level != null) {
      // Load classes for selected level
      final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
      final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
      context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, level.levelCode);
    }
  }

  void _onClassChanged(TeacherClassModels? newValue) {
    setState(() {
      _selectedClass = newValue;
      _absences.clear(); // Clear local absences tracking for new class
    });
    if (newValue != null) {
      final date = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());
      context.read<HomeCubit>().getClassAbsent(classCode: newValue.classCode, date: date);
      context.read<HomeCubit>().studentData(code: newValue.classCode);
    }
  }

  void _saveAttendance() {
    if (_selectedClass == null || _selectedLevel == null) {
      CommonMethods.showToast(
        message: AppLocalKay.user_management_select_classs.tr(),
        backgroundColor: AppColor.errorColor(context),
      );
      return;
    }

    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd', 'en').format(now);

    final List<ClassAbsentItem> absentList = [];
    final studentData = context.read<HomeCubit>().state.studentDataStatus.data;
    if (studentData != null) {
      for (var student in studentData.students) {
        final record = _absences[student.studentCode];
        if (record != null) {
          absentList.add(
            ClassAbsentItem(
              studentCode: student.studentCode,
              absentType: record.type,
              notes: record.notes.isEmpty ? AppLocalKay.absence_from_teacher.tr() : record.notes,
            ),
          );
        }
      }
    }

    final existingAbsencesString = context.read<HomeCubit>().state.getClassAbsentStatus.data ?? "";
    final bool hasExistingAbsences =
        existingAbsencesString.isNotEmpty && existingAbsencesString != "[]";

    final request = AddClassAbsentRequestModel(
      classCodes: (hasExistingAbsences || absentList.length > 1)
          ? _selectedClass!.classCode.toString()
          : "",
      sectionCode: int.tryParse(HiveMethods.getUserSection().toString()) ?? 0,
      stageCode: int.tryParse(HiveMethods.getUserStage().toString()) ?? 0,
      levelCode: _selectedLevel!.levelCode,
      classCode: _selectedClass!.classCode,
      absentDate: date,
      notes: AppLocalKay.absence_from_teacher.tr(),
      classAbsentList: absentList,
    );

    context.read<HomeCubit>().addClassAbsent(request: request);
  }

  void _showAbsenceBottomSheet(HomeState state) {
    final studentData = state.studentDataStatus.data;
    if (studentData == null || studentData.students.isEmpty) {
      CommonMethods.showToast(message: AppLocalKay.choose_class_first.tr());
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AbsenceSelectionBottomSheet(
          students: studentData.students,
          initialAbsences: Map.from(_absences),
          onConfirm: (updatedAbsences) {
            setState(() {
              _absences.clear();
              _absences.addAll(updatedAbsences);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.record_absence.tr(), style: AppTextStyle.appBarStyle(context)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.addClassAbsentStatus != current.addClassAbsentStatus,
        listener: (context, state) {
          if (state.addClassAbsentStatus.isSuccess) {
            CommonMethods.showToast(message: state.addClassAbsentStatus.data?.msg ?? "");
            setState(() => _absences.clear());
            if (_selectedClass != null) {
              final date = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());
              context.read<HomeCubit>().getClassAbsent(
                classCode: _selectedClass!.classCode,
                date: date,
              );
            }
          } else if (state.addClassAbsentStatus.isFailure) {
            CommonMethods.showToast(
              message: state.addClassAbsentStatus.error ?? "",
              backgroundColor: AppColor.errorColor(context, listen: false),
            );
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            int absentCount = _absences.length;
            int totalCount = state.studentDataStatus.data?.students.length ?? 0;

            return Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: _buildSelectionCard(state),
                  ),
                  Gap(20.h),
                  if (_selectedClass != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: _buildAbsenceSummaryCard(absentCount, totalCount, state),
                    ),
                  const Spacer(),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: CustomButton(
                      child: state.addClassAbsentStatus.isLoading
                          ? CustomLoading(color: AppColor.whiteColor(context), size: 20.sp)
                          : Text(
                              AppLocalKay.user_management_save.tr(),
                              style: AppTextStyle.titleMedium(
                                context,
                              ).copyWith(color: AppColor.whiteColor(context)),
                            ),
                      radius: 12.r,
                      onPressed: state.addClassAbsentStatus.isLoading ? null : _saveAttendance,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectionCard(HomeState state) {
    final levels = state.teacherLevelStatus.data ?? [];
    final classes = state.teacherClassesStatus.data ?? [];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.05)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.class_details.tr(),
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(16.h),
          CustomDropdownFormField(
            value: _selectedLevel,
            errorText: '',
            submitted: false,
            hint: AppLocalKay.select_level.tr(),
            items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l.levelName))).toList(),
            onChanged: state.teacherLevelStatus.isLoading ? null : _onLevelChanged,
          ),
          Gap(12.h),
          CustomDropdownFormField(
            value: _selectedClass,
            errorText: '',
            submitted: false,
            hint: AppLocalKay.select_class.tr(),
            items: classes
                .map((c) => DropdownMenuItem(value: c, child: Text(c.classNameAr)))
                .toList(),
            onChanged: _selectedLevel == null || state.teacherClassesStatus.isLoading
                ? null
                : _onClassChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenceSummaryCard(int absentCount, int totalCount, HomeState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context),
            AppColor.primaryColor(context).withValues(alpha: (0.7)),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor(context).withValues(alpha: (0.3)),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryStat(
                AppLocalKay.total_students.tr(),
                totalCount.toString(),
                Icons.people,
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildSummaryStat(
                AppLocalKay.absent_students.tr(),
                absentCount.toString(),
                Icons.person_off,
              ),
            ],
          ),
          Gap(24.h),
          ElevatedButton(
            onPressed: state.studentDataStatus.isLoading
                ? null
                : () => _showAbsenceBottomSheet(state),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.whiteColor(context),
              foregroundColor: AppColor.primaryColor(context),
              elevation: 0,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            ),
            child: state.studentDataStatus.isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    AppLocalKay.select_absent_students.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColor.whiteColor(context), size: 24.sp),
        Gap(4.h),
        Text(
          value,
          style: AppTextStyle.headlineLarge(
            context,
          ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.whiteColor(context)),
        ),
      ],
    );
  }
}

class _AbsenceSelectionBottomSheet extends StatefulWidget {
  final List<StudentItem> students;
  final Map<int, AbsenceRecord> initialAbsences;
  final Function(Map<int, AbsenceRecord>) onConfirm;

  const _AbsenceSelectionBottomSheet({
    required this.students,
    required this.initialAbsences,
    required this.onConfirm,
  });

  @override
  State<_AbsenceSelectionBottomSheet> createState() => _AbsenceSelectionBottomSheetState();
}

class _AbsenceSelectionBottomSheetState extends State<_AbsenceSelectionBottomSheet> {
  late Map<int, AbsenceRecord> _localAbsences;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localAbsences = Map.from(widget.initialAbsences);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = widget.students
        .where((s) => s.studentName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColor.grey300Color(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(16.h),
          Text(
            AppLocalKay.select_absent_students.tr(),
            style: AppTextStyle.headlineSmall(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(16.h),
          TextFormField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: AppLocalKay.search_student.tr(),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColor.surfaceColor(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Gap(16.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                final record = _localAbsences[student.studentCode];
                final isAbsent = record != null;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceColor(context),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isAbsent
                          ? AppColor.errorColor(context).withValues(alpha: (0.3))
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.blackColor(context).withValues(alpha: (0.02)),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: isAbsent
                              ? AppColor.errorColor(context).withValues(alpha: (0.1))
                              : AppColor.grey300Color(context),
                          child: Text(
                            student.studentName.isNotEmpty
                                ? student.studentName.substring(0, 1)
                                : "?",
                            style: TextStyle(
                              color: isAbsent ? AppColor.errorColor(context) : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          student.studentName,
                          style: AppTextStyle.bodyMedium(
                            context,
                          ).copyWith(fontWeight: isAbsent ? FontWeight.bold : FontWeight.normal),
                        ),
                        subtitle: Text("ID: ${student.studentCode}"),
                        trailing: Checkbox(
                          value: isAbsent,
                          activeColor: AppColor.errorColor(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _localAbsences[student.studentCode] = AbsenceRecord(
                                  type: 0,
                                  notes: "",
                                );
                              } else {
                                _localAbsences.remove(student.studentCode);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isAbsent) {
                              _localAbsences.remove(student.studentCode);
                            } else {
                              _localAbsences[student.studentCode] = AbsenceRecord(
                                type: 0,
                                notes: "",
                              );
                            }
                          });
                        },
                      ),
                      if (isAbsent)
                        FadeIn(
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Gap(8.h),
                              Row(
                                children: [
                                  _buildTypeChip(AppLocalKay.absent.tr(), 0, record!.type == 0, (
                                    type,
                                  ) {
                                    setState(() {
                                      _localAbsences[student.studentCode] = AbsenceRecord(
                                        type: type,
                                        notes: record.notes,
                                      );
                                    });
                                  }),
                                  Gap(12.w),
                                  _buildTypeChip(AppLocalKay.excused.tr(), 1, record.type == 1, (
                                    type,
                                  ) {
                                    setState(() {
                                      _localAbsences[student.studentCode] = AbsenceRecord(
                                        type: type,
                                        notes: record.notes,
                                      );
                                    });
                                  }),
                                ],
                              ),
                              Gap(12.h),
                              TextFormField(
                                initialValue: record.notes,
                                decoration: InputDecoration(
                                  hintText: AppLocalKay.add_notes.tr(),
                                  filled: true,
                                  fillColor: AppColor.surfaceVariant(context),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: AppTextStyle.bodySmall(context),
                                onChanged: (val) {
                                  _localAbsences[student.studentCode] = AbsenceRecord(
                                    type: record.type,
                                    notes: val,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: CustomButton(
              text: "${AppLocalKay.confirm.tr()} (${_localAbsences.length})",
              onPressed: () {
                widget.onConfirm(_localAbsences);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, int type, bool isSelected, Function(int) onSelected) {
    return InkWell(
      onTap: () => onSelected(type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor(context) : AppColor.surfaceVariant(context),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(
            color: isSelected ? AppColor.whiteColor(context) : AppColor.greyColor(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
