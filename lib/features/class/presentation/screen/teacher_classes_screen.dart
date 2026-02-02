import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart' as old_models;
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_classes_list.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_info_card.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_quick_stats.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TeacherClassesScreen extends StatefulWidget {
  final int? classCode;
  const TeacherClassesScreen({super.key, this.classCode});

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  @override
  void initState() {
    super.initState();
    final userCode = int.tryParse(HiveMethods.getUserCode()) ?? 0;
    final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
    final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
    final levelCode = int.tryParse(HiveMethods.getUserLevelCode().toString()) ?? 0;

    context.read<HomeCubit>().teacherCourses(userCode);
    context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, 111);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.classestitle.tr(),
          style: AppTextStyle.titleMedium(context, color: AppColor.blackColor(context)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.teacherClassesStatus.isLoading || state.teacherCoursesStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.teacherClassesStatus.isFailure) {
            return Center(child: Text(state.teacherClassesStatus.error ?? "حدث خطأ ما"));
          } else if (state.teacherClassesStatus.isSuccess) {
            final classes = state.teacherClassesStatus.data ?? [];
            final courses = state.teacherCoursesStatus.data ?? [];
            final mainSubject = courses.isNotEmpty ? courses.first.courseName : 'مدرس';

            return RefreshIndicator(
              onRefresh: () async {
                final userCode = int.tryParse(HiveMethods.getUserCode()) ?? 0;
                final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
                final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;

                context.read<HomeCubit>().teacherCourses(userCode);
                context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, 111);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TeacherInfoCard(
                      teacherInfo: old_models.TeacherInfo(
                        name: HiveMethods.getUserName(),
                        subject: mainSubject,
                        email: HiveMethods.getUserCompanyName(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TeacherQuickStats(
                      stats: old_models.ClassStats(
                        totalStudents: classes.fold(
                          0,
                          (sum, c) => sum + (c.newStudent ?? 0) + (c.oldStudent ?? 0),
                        ),
                        totalAssignments: 0,
                        attendanceRate: 0.0,
                      ),
                    ),
                    const SizedBox(height: 20),
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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
