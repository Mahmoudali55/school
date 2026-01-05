import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart' as old_models;
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_classes_list.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_info_card.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_quick_stats.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

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
      body: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          if (state is ClassLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClassError) {
            return Center(child: Text(state.message));
          } else if (state is ClassLoaded) {
            final classes = state.classes.cast<TeacherClassModel>();
            return RefreshIndicator(
              onRefresh: () async {
                // In a real app, this would refresh ClassCubit
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TeacherInfoCard(
                      teacherInfo: old_models.TeacherInfo(
                        name: 'أ. أحمد محمد',
                        subject: 'مدرس الرياضيات',
                        email: 'ahmed@school.edu',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TeacherQuickStats(
                      stats: old_models.ClassStats(
                        totalStudents: classes.fold(0, (sum, c) => sum + c.studentCount),
                        totalAssignments: classes.fold(0, (sum, c) => sum + c.assignments),
                        attendanceRate: 0.95,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TeacherClassesList(
                        classes: classes
                            .map(
                              (c) => old_models.ClassInfo(
                                id: c.id,
                                className: c.className,
                                studentCount: c.studentCount,
                                schedule: c.schedule,
                                time: c.time,
                                room: c.room,
                                progress: c.progress,
                                assignments: c.assignments,
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
