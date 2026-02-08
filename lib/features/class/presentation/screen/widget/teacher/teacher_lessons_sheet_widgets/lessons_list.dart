import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/empty_lessons_widget.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/lesson_card_widget.dart';

class LessonsList extends StatelessWidget {
  final VoidCallback? onRefresh;
  const LessonsList({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (_, state) {
        final status = state.getLessonsStatus;

        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (status.isFailure) {
          return Center(
            child: Text(
              status.error ?? '',
              style: AppTextStyle.bodyLarge(context).copyWith(color: AppColor.errorColor(context)),
            ),
          );
        }

        final lessons = status.data?.lessons ?? [];

        if (lessons.isEmpty) {
          return EmptyLessons();
        }

        return ListView.separated(
          padding: EdgeInsets.only(bottom: 12.h),
          itemCount: lessons.length,
          separatorBuilder: (_, __) => Gap(12.h),
          itemBuilder: (_, index) {
            final lesson = lessons[index];
            return LessonCard(lesson: lesson, onEditSuccess: onRefresh);
          },
        );
      },
    );
  }
}
