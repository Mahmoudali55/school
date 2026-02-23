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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(AppLocalKay.saveSuccess.tr())));
          }
          if (state.generateScheduleStatus.isSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(AppLocalKay.generation_success.tr())));
          }
          if (state.generateScheduleStatus.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.generateScheduleStatus.message ?? AppLocalKay.generation_failure.tr(),
                ),
              ),
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
                Gap(16.h),

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
                    color: Colors.orange,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.8,
                          child: ScheduleTableBottomSheet(
                            schedule: state.generatedSchedules,
                            className: state.selectedClass?.classNameAr ?? 'Class',
                          ),
                        ),
                      );
                    },
                  ),

                  Gap(12.h),
                  CustomButton(
                    text: AppLocalKay.save.tr(),
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
