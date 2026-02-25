import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';
import 'package:my_template/features/class/presentation/execution/widget/schedule_table_bottom_sheet.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';

class AdminScheduleGeneratorScreen extends StatefulWidget {
  const AdminScheduleGeneratorScreen({super.key});

  @override
  State<AdminScheduleGeneratorScreen> createState() => _AdminScheduleGeneratorScreenState();
}

class _AdminScheduleGeneratorScreenState extends State<AdminScheduleGeneratorScreen> {
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    // Assuming we have a way to get the current userId, for now passing a placeholder or getting it from a shared state if available.
    // In this app, many repositories use userId.
    context.read<ScheduleCubit>().getSections('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.generate_schedule.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ScheduleCubit, ScheduleState>(
        listener: (context, state) {
          if (state.saveScheduleStatus.isSuccess) {
            CommonMethods.showToast(message: state.saveScheduleStatus.data?.msg ?? '');
          }
          if (state.saveScheduleStatus.isFailure) {
            CommonMethods.showToast(
              message: state.saveScheduleStatus.error ?? '',
              backgroundColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalKay.ai_generation.tr(), style: AppTextStyle.bodyMedium(context)),
                Gap(12.h),

                // Section Dropdown
                CustomDropdownFormField<SectionDataModel>(
                  hint: AppLocalKay.select_section.tr(),
                  value: (state.sectionDataStatus.data ?? []).contains(state.selectedSection)
                      ? state.selectedSection
                      : null,
                  items: (state.sectionDataStatus.data ?? [])
                      .toSet() // Ensure uniqueness
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.sectionName)))
                      .toList(),
                  onChanged: (val) => context.read<ScheduleCubit>().onSectionChanged(val),
                  errorText: AppLocalKay.select_section.tr(),
                  submitted: _submitted,
                ),
                Gap(12.h),

                // Stage Dropdown
                CustomDropdownFormField<StageDataModel>(
                  hint: AppLocalKay.setting_school
                      .tr(), // Reusing school/stage keys if specific ones missing
                  value: (state.stageDataStatus.data ?? []).contains(state.selectedStage)
                      ? state.selectedStage
                      : null,
                  items: (state.stageDataStatus.data ?? [])
                      .toSet() // Ensure uniqueness
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.stageNameAr)))
                      .toList(),
                  onChanged: (val) => context.read<ScheduleCubit>().onStageChanged(val),
                  errorText: AppLocalKay.setting_school.tr(),
                  submitted: _submitted,
                ),
                Gap(12.h),

                // Level Dropdown
                CustomDropdownFormField<LevelModel>(
                  hint: AppLocalKay.level.tr(),
                  value: (state.levelDataStatus.data ?? []).contains(state.selectedLevel)
                      ? state.selectedLevel
                      : null,
                  items: (state.levelDataStatus.data ?? [])
                      .toSet() // Ensure uniqueness
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.levelName)))
                      .toList(),
                  onChanged: (val) => context.read<ScheduleCubit>().onLevelChanged(val),
                  errorText: AppLocalKay.level.tr(),
                  submitted: _submitted,
                ),
                Gap(12.h),

                if (state.selectedLevel != null) ...[
                  Text(
                    "إعدادات الجدول",
                    style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(8.h),

                  // Start Time
                  Row(
                    children: [
                      Expanded(child: Text("وقت بداية اليوم")),
                      TextButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: state.startTime,
                          );
                          if (picked != null) {
                            context.read<ScheduleCubit>().updateStartTime(picked);
                          }
                        },
                        child: Text(state.startTime.format(context)),
                      ),
                    ],
                  ),

                  // Periods Count
                  Row(
                    children: [
                      Expanded(child: Text("عدد الحصص (يوم عادي)")),
                      DropdownButton<int>(
                        value: state.periodsCount,
                        items: List.generate(
                          8,
                          (i) => i + 3,
                        ).map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                        onChanged: (val) => context.read<ScheduleCubit>().updatePeriodsCount(val!),
                      ),
                    ],
                  ),

                  // Thursday Periods
                  Row(
                    children: [
                      Expanded(child: Text("عدد حصص يوم الخميس")),
                      DropdownButton<int>(
                        value: state.thursdayPeriodsCount,
                        items: List.generate(
                          8,
                          (i) => i + 3,
                        ).map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                        onChanged: (val) =>
                            context.read<ScheduleCubit>().updateThursdayPeriodsCount(val!),
                      ),
                    ],
                  ),

                  // Period Duration
                  Row(
                    children: [
                      Expanded(child: Text("مدة الحصة (دقيقة)")),
                      DropdownButton<int>(
                        value: state.periodDuration,
                        items: [
                          30,
                          35,
                          40,
                          45,
                          50,
                          55,
                          60,
                        ].map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                        onChanged: (val) =>
                            context.read<ScheduleCubit>().updatePeriodDuration(val!),
                      ),
                    ],
                  ),

                  // Break Duration
                  Row(
                    children: [
                      Expanded(child: Text("مدة الفسحة (دقيقة)")),
                      DropdownButton<int>(
                        value: state.breakDuration,
                        items: [
                          5,
                          10,
                          15,
                          20,
                          25,
                          30,
                        ].map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                        onChanged: (val) => context.read<ScheduleCubit>().updateBreakDuration(val!),
                      ),
                    ],
                  ),

                  // Break After Period
                  Row(
                    children: [
                      Expanded(child: Text("الفسحة بعد الحصة رقم")),
                      DropdownButton<int>(
                        value: state.breakAfterPeriod,
                        items: List.generate(
                          5,
                          (i) => i + 1,
                        ).map((e) => DropdownMenuItem(value: e, child: Text("$e"))).toList(),
                        onChanged: (val) =>
                            context.read<ScheduleCubit>().updateBreakAfterPeriod(val!),
                      ),
                    ],
                  ),
                  Gap(12.h),
                ],

                // Class Dropdown
                CustomDropdownFormField<TeacherClassModels>(
                  hint: AppLocalKay.select_class_to_generate.tr(),
                  value: (state.classDataStatus.data ?? []).contains(state.selectedClass)
                      ? state.selectedClass
                      : null,
                  items: (state.classDataStatus.data ?? [])
                      .toSet() // Ensure uniqueness
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.classNameAr ?? 'Class ${e.classCode}'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => context.read<ScheduleCubit>().onClassChanged(val),
                  errorText: AppLocalKay.select_class_to_generate.tr(),
                  submitted: _submitted,
                ),
                Gap(24.h),

                CustomButton(
                  text: AppLocalKay.ai_generation.tr(),
                  cubitState: state.generateScheduleStatus,
                  radius: 12.r,
                  onPressed: () {
                    setState(() => _submitted = true);
                    if (state.selectedClass != null) {
                      context.read<ScheduleCubit>().generateAICalendar();
                    }
                  },
                ),

                if (state.generatedSchedules.isNotEmpty && state.selectedClass != null) ...[
                  Gap(32.h),
                  Text(AppLocalKay.review_schedule.tr(), style: AppTextStyle.bodyMedium(context)),
                  Gap(16.h),

                  CustomButton(
                    text: AppLocalKay.review_schedule.tr(),
                    radius: 12.r,
                    color: Colors.orange,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (bottomSheetContext) => BlocProvider.value(
                          value: context.read<ScheduleCubit>(),
                          child: FractionallySizedBox(
                            heightFactor: 0.8,
                            child: ScheduleTableBottomSheet(
                              classCode: state.selectedClass!.classCode,
                              schedule: state.generatedSchedules,
                              className: state.selectedClass?.classNameAr ?? 'Class',
                              startTime: state.startTime,
                              periodsCount: state.periodsCount,
                              periodDuration: state.periodDuration,
                              breakDuration: state.breakDuration,
                              thursdayPeriodsCount: state.thursdayPeriodsCount,
                              breakAfterPeriod: state.breakAfterPeriod,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Gap(12.h),
                  CustomButton(
                    text: AppLocalKay.save.tr(),
                    radius: 12.r,
                    cubitState: state.saveScheduleStatus,
                    onPressed: () {
                      context.read<ScheduleCubit>().saveSchedule(state.selectedClass!.classCode);
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
