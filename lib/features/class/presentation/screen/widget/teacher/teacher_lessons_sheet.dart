import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/lessons_action_buttons.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/lessons_header.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/lessons_list.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/view/execution/upload_lesson_screen.dart';

class TeacherLessonsSheet extends StatefulWidget {
  final ClassInfo classInfo;
  final ClassCubit classCubit;
  final HomeCubit homeCubit;

  const TeacherLessonsSheet({
    super.key,
    required this.classInfo,
    required this.classCubit,
    required this.homeCubit,
  });

  @override
  State<TeacherLessonsSheet> createState() => _TeacherLessonsSheetState();
}

class _TeacherLessonsSheetState extends State<TeacherLessonsSheet> {
  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  void _fetchLessons() {
    widget.classCubit.getLessons(code: int.tryParse(widget.classInfo.id) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassCubit, ClassState>(
      listenWhen: (previous, current) => previous.deleteLessonStatus != current.deleteLessonStatus,
      listener: (context, state) {
        if (state.deleteLessonStatus.isSuccess) {
          CommonMethods.showToast(
            message: state.deleteLessonStatus.data?.errorMsg ?? '',
            type: ToastType.success,
          );
          _fetchLessons();
        } else if (state.deleteLessonStatus.isFailure) {
          CommonMethods.showToast(
            message: state.deleteLessonStatus.error ?? '',
            type: ToastType.error,
          );
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                const LessonsHeader(),
                Gap(16.h),
                const Expanded(child: LessonsList()),
                Gap(12.h),
                LessonsActionButtons(
                  onCreate: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: widget.homeCubit,
                          child: const UploadLessonScreen(),
                        ),
                      ),
                    );
                    if (result == true) _fetchLessons();
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
