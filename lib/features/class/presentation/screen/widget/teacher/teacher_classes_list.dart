import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/attendance_sheet.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

import 'students_list_sheet.dart';
import 'teacher_assignments_sheet.dart';
import 'teacher_assignments_sheet_widgets/teacher_class_card.dart';

class TeacherClassesList extends StatelessWidget {
  final List<ClassInfo> classes;

  const TeacherClassesList({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalKay.empty_classes.tr(),
              style: AppTextStyle.titleMedium(context, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(AppLocalKay.empty_classes_hint.tr(), style: AppTextStyle.bodyMedium(context)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        return TeacherClassCard(
          classInfo: classInfo,
          onStudentsPressed: () => _showStudentsSheet(context, classInfo),
          onAssignmentsPressed: () => _showAssignmentsSheet(context, classInfo),
          onAttendancePressed: () => _showAttendanceSheet(context, classInfo),
          onLessonsPressed: () => _showLessonsSheet(context, classInfo),
        );
      },
    );
  }

  void _showLessonsSheet(BuildContext context, ClassInfo classInfo) {
    final classCubit = context.read<ClassCubit>();
    final homeCubit = context.read<HomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: classCubit..getLessons(),
          child: TeacherLessonsSheet(
            classInfo: classInfo,
            classCubit: classCubit,
            homeCubit: homeCubit,
          ),
        );
      },
    );
  }

  void _showStudentsSheet(BuildContext context, ClassInfo classInfo) {
    final classCubit = context.read<ClassCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: classCubit..studentData(code: int.tryParse(classInfo.id) ?? 0),
          child: StudentsListSheet(),
        );
      },
    );
  }

  void _showAssignmentsSheet(BuildContext context, ClassInfo classInfo) {
    final classCubit = context.read<ClassCubit>();
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: classCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: TeacherAssignmentsSheet(
            classInfo: classInfo,
            classCubit: classCubit,
            homeCubit: homeCubit,
          ),
        );
      },
    );
  }

  void _showAttendanceSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => sl<ClassCubit>(),
          child: AttendanceSheet(classInfo: classInfo),
        );
      },
    );
  }
}
