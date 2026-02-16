import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  @override
  void initState() {
    super.initState();
    final userCode = HiveMethods.getUserid();
    context.read<ClassCubit>().sectionData(userId: userCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.w, horizontal: 20.w),
        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            final uniqueStages = (state.stageDataStatus.data ?? []).toSet().toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.select_section.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(8.h),
                CustomDropdownFormField<SectionDataModel>(
                  hint: AppLocalKay.select_section.tr(),
                  value: state.selectedSection,
                  items: (state.sectionDataStatus.data ?? []).map((section) {
                    return DropdownMenuItem<SectionDataModel>(
                      value: section,
                      child: Text(section.sectionName),
                    );
                  }).toList(),
                  onChanged: (SectionDataModel? section) {
                    context.read<ClassCubit>().onSectionChanged(section);
                  },
                  errorText: '',
                  submitted: false,
                ),
                Gap(5.h),
                Text(
                  context.locale.languageCode == 'ar' ? 'اختر المرحلة' : 'Select Stage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(8.h),
                CustomDropdownFormField<StageDataModel>(
                  hint: context.locale.languageCode == 'ar' ? 'اختر المرحلة' : 'Select Stage',
                  value: (uniqueStages.contains(state.selectedStage)) ? state.selectedStage : null,
                  items: uniqueStages.map((stage) {
                    return DropdownMenuItem<StageDataModel>(
                      value: stage,
                      child: Text(stage.stageNameAr),
                    );
                  }).toList(),
                  onChanged: state.selectedSection == null || state.stageDataStatus.isLoading
                      ? null
                      : (StageDataModel? stage) {
                          context.read<ClassCubit>().onStageChanged(stage);
                        },
                  errorText: '',
                  submitted: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
