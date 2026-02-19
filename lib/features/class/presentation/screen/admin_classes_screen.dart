import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/class_card.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/class_details_bottom_sheet.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/students_bottom_sheet.dart';

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
    context.read<ClassCubit>().clearSelection(); // Reset selection on init
    context.read<ClassCubit>().sectionData(userId: userCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.classes.tr(),
          style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          final uniqueStages = (state.stageDataStatus.data ?? []).toSet().toList();
          final uniqueLevels = (state.levelDataStatus?.data ?? []).toSet().toList();
          final classes = state.classDataStatus?.data ?? [];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Stats Row - Integrated but subtle
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  child: Row(
                    children: [
                      _buildRefinedStat(
                        context,
                        AppLocalKay.noClasses.tr(),
                        "${classes.length}",
                        Icons.school_outlined,
                        AppColor.primaryColor(context),
                      ),
                      Gap(12.w),
                      _buildRefinedStat(
                        context,
                        AppLocalKay.total_students.tr(),
                        "${classes.fold(0, (sum, item) => sum + (item.newStudent ?? 0) + (item.oldStudent ?? 0))}",
                        Icons.people_outline_rounded,
                        AppColor.secondAppColor(context),
                      ),
                    ],
                  ),
                ),
              ),

              // Filters Panel - Clean and Compact
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor(context),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColor.borderColor(context)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.blackColor(context).withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 18.sp,
                            color: AppColor.primaryColor(context),
                          ),
                          Gap(8.w),
                          Text(
                            AppLocalKay.clearResults.tr(),
                            style: AppTextStyle.titleSmall(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.textColor(context),
                            ),
                          ),
                        ],
                      ),
                      Gap(20.h),
                      _buildRefinedDropdown<SectionDataModel>(
                        context,
                        AppLocalKay.select_section.tr(),
                        state.selectedSection,
                        (state.sectionDataStatus.data ?? []).map((section) {
                          return DropdownMenuItem<SectionDataModel>(
                            value: section,
                            child: Text(section.sectionName),
                          );
                        }).toList(),
                        (val) => context.read<ClassCubit>().onSectionChanged(val),
                      ),
                      Gap(16.h),
                      _buildRefinedDropdown<StageDataModel>(
                        context,
                        AppLocalKay.stage.tr(),
                        (uniqueStages.contains(state.selectedStage)) ? state.selectedStage : null,
                        uniqueStages.map((stage) {
                          return DropdownMenuItem<StageDataModel>(
                            value: stage,
                            child: Text(stage.stageNameAr),
                          );
                        }).toList(),
                        (val) => context.read<ClassCubit>().onStageChanged(val),
                      ),
                      Gap(16.h),
                      _buildRefinedDropdown<LevelModel>(
                        context,
                        AppLocalKay.select_classs.tr(),
                        (uniqueLevels.contains(state.selectedLevel)) ? state.selectedLevel : null,
                        uniqueLevels.map((level) {
                          return DropdownMenuItem<LevelModel>(
                            value: level,
                            child: Text(level.levelName),
                          );
                        }).toList(),
                        state.selectedStage == null || (state.levelDataStatus?.isLoading ?? false)
                            ? null
                            : (val) => context.read<ClassCubit>().onLevelChanged(val),
                      ),
                    ],
                  ),
                ),
              ),

              // Header for Results
              if (state.classDataStatus?.isSuccess ?? false)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalKay.classesTitle.tr(),
                          style: AppTextStyle.titleSmall(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "(${classes.length})",
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: AppColor.greyColor(context)),
                        ),
                      ],
                    ),
                  ),
                ),

              // List of Classes
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                sliver: _buildRefinedListContent(context, state),
              ),

              SliverGap(30.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRefinedStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.borderColor(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            Gap(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: AppColor.textColor(context)),
                ),
                Text(
                  label,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefinedDropdown<T>(
    BuildContext context,
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    void Function(T?)? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodySmall(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: AppColor.greyColor(context)),
        ),
        Gap(8.h),
        CustomDropdownFormField<T>(
          hint: label,
          value: value,
          items: items,
          onChanged: onChanged,
          errorText: '',
          submitted: false,
        ),
      ],
    );
  }

  Widget _buildRefinedListContent(BuildContext context, ClassState state) {
    if (state.classDataStatus?.isLoading ?? false) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()),
        ),
      );
    }

    if (state.classDataStatus?.isFailure ?? false) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.errorColor(context).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: AppColor.errorColor(context)),
              Gap(12.w),
              Expanded(
                child: Text(
                  state.classDataStatus!.error ?? 'Error',
                  style: TextStyle(color: AppColor.errorColor(context)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final classes = state.classDataStatus?.data ?? [];
    if (classes.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 60.h),
          child: Column(
            children: [
              Icon(Icons.class_outlined, size: 64.sp, color: AppColor.grey200Color(context)),
              Gap(16.h),
              Text(
                context.locale.languageCode == 'ar'
                    ? 'لا توجد فصول دراسية حالياً'
                    : 'No classes matching filters',
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.grey600Color(context)),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final classModel = classes[index];
        return ClassCard(
          classModel: classModel,
          onViewDetails: () =>
              _showDetailsBottomSheet(context, classModel.classNameAr, classModel.classCode),
          onEdit: () {},
          onManageStudents: () =>
              _showStudentsBottomSheet(context, classModel.classNameAr, classModel.classCode),
        );
      }, childCount: classes.length),
    );
  }

  void _showStudentsBottomSheet(BuildContext context, String className, int classCode) {
    final classCubit = context.read<ClassCubit>();
    classCubit.studentData(code: classCode);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: classCubit,
        child: StudentsBottomSheet(className: className, classCode: classCode),
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context, String className, int classCode) {
    final classCubit = context.read<ClassCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: classCubit,
        child: ClassDetailsBottomSheet(className: className, classCode: classCode),
      ),
    );
  }
}
