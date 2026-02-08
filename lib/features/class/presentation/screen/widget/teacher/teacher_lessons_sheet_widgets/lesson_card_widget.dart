import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/attachment_button_widget.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/info_chip.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/view/execution/upload_lesson_screen.dart';

class LessonCard extends StatelessWidget {
  final lesson;
  final VoidCallback? onEditSuccess;

  const LessonCard({super.key, required this.lesson, this.onEditSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header (Title + Delete)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  lesson.lesson,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Gap(8.w),
              Material(
                color: AppColor.accentColor(context).withOpacity(0.08),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<HomeCubit>(),
                          child: UploadLessonScreen(lesson: lesson),
                        ),
                      ),
                    );
                    if (result == true && onEditSuccess != null) {
                      onEditSuccess!();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.edit_rounded,
                      color: AppColor.accentColor(context),
                      size: 20.w,
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              Material(
                color: AppColor.errorColor(context).withOpacity(0.08),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text(AppLocalKay.delete.tr()),
                        content: Text(
                          AppLocalKay.delete_lesson.tr(),
                          style: AppTextStyle.bodyMedium(context),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(AppLocalKay.cancel.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              context.read<ClassCubit>().deleteStudent(studentCode: lesson.id);
                            },
                            child: Text(
                              AppLocalKay.delete.tr(),
                              style: TextStyle(
                                color: AppColor.errorColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.delete_rounded,
                      color: AppColor.errorColor(context),
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 Notes
          if (lesson.notes != null && lesson.notes!.isNotEmpty) ...[
            Gap(8.h),
            Text(
              lesson.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.greyColor(context).withOpacity(0.8), height: 1.4),
            ),
          ],

          Gap(14.h),
          Divider(height: 1, color: Colors.grey.shade100),
          Gap(12.h),

          /// 🔹 Bottom row
          Row(
            children: [
              /// Date
              InfoChip(icon: Icons.calendar_today_rounded, label: lesson.lessonDate),

              const Spacer(),

              /// Attachment Button
              AttachmentButton(lessonPath: lesson.lessonPath),
            ],
          ),
        ],
      ),
    );
  }
}
