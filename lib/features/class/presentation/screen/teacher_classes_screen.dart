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
import 'package:my_template/features/class/data/model/teacher_classes_models.dart' as old_models;
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_classes_list.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_info_card.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TeacherClassesScreen extends StatefulWidget {
  final int? classCode;
  const TeacherClassesScreen({super.key, this.classCode});

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  int? _selectedLevelCode;

  @override
  void initState() {
    super.initState();
    final userCode = int.tryParse(HiveMethods.getUserCode()) ?? 0;
    final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;

    context.read<HomeCubit>().teacherCourses(userCode);
    context.read<HomeCubit>().teacherLevel(stageCode);
  }

  void _fetchClasses() {
    if (_selectedLevelCode == null) return;
    final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
    final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
    context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, _selectedLevelCode!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.classestitle.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.teacherLevelStatus.isSuccess && _selectedLevelCode == null) {
            final levels = state.teacherLevelStatus.data ?? [];
            if (levels.isNotEmpty) {
              setState(() {
                _selectedLevelCode = levels.first.levelCode;
              });
              _fetchClasses();
            }
          }
        },
        builder: (context, state) {
          if (state.teacherLevelStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.teacherLevelStatus.isFailure) {
            return Center(
              child: Text(state.teacherLevelStatus.error ?? "حدث خطأ في تحميل المراحل"),
            );
          } else if (state.teacherLevelStatus.isSuccess) {
            final levels = state.teacherLevelStatus.data ?? [];

            return RefreshIndicator(
              onRefresh: () async {
                final userCode = int.tryParse(HiveMethods.getUserCode()) ?? 0;
                final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
                context.read<HomeCubit>().teacherCourses(userCode);
                context.read<HomeCubit>().teacherLevel(stageCode);
                if (_selectedLevelCode != null) {
                  _fetchClasses();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Classes Content
                    if (state.teacherClassesStatus.isLoading ||
                        state.teacherCoursesStatus.isLoading)
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    else if (state.teacherClassesStatus.isFailure)
                      Expanded(
                        child: Center(
                          child: Text(state.teacherClassesStatus.error ?? "حدث خطأ ما"),
                        ),
                      )
                    else if (state.teacherClassesStatus.isSuccess) ...[
                      Builder(
                        builder: (context) {
                          final classes = state.teacherClassesStatus.data ?? [];
                          final courses = state.teacherCoursesStatus.data ?? [];
                          final mainSubject = courses.isNotEmpty
                              ? courses.first.courseName
                              : 'مدرس';

                          return Expanded(
                            child: Column(
                              children: [
                                TeacherInfoCard(
                                  teacherInfo: old_models.TeacherInfo(
                                    name: HiveMethods.getUserName(),
                                    subject: mainSubject,
                                    email: HiveMethods.getUserCompanyName(),
                                  ),
                                ),
                                Gap(10.h),
                                if (levels.isNotEmpty) ...[
                                  CustomDropdownFormField<int>(
                                    value: _selectedLevelCode,
                                    hint: AppLocalKay.user_management_class.tr(),
                                    items: levels
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.levelCode,
                                            child: Text(e.levelName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        _selectedLevelCode = v;
                                      });
                                      _fetchClasses();
                                    },
                                    errorText: '',
                                    submitted: false,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                const SizedBox(height: 10),
                                Expanded(
                                  child: TeacherClassesList(
                                    classes: classes
                                        .map(
                                          (c) => old_models.ClassInfo(
                                            id: c.classCode.toString(),
                                            className: c.classNameAr,
                                            studentCount: (c.newStudent ?? 0) + (c.oldStudent ?? 0),
                                            schedule: c.deltaConfig,
                                            time: '',
                                            room: c.floorName ?? '',
                                            progress: 0.0,
                                            assignments: 0,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
