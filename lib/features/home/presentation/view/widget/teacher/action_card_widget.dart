import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/view/execution/create_assignment_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/recording_absence_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/teacher_digital_library_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/teacher_full_schedule_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/teacher_grades_exams_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/upload_lesson_screen.dart';

class ActionCardWidget extends StatelessWidget {
  final QuickAction action;
  const ActionCardWidget({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToScreen(context, action.key);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: action.color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: action.color.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: action.color, size: 24.w),
            ),
            Gap(8.h),
            Flexible(
              child: Text(
                action.title,
                style: AppTextStyle.titleSmall(
                  context,
                  color: AppColor.blackColor(context),
                ).copyWith(fontWeight: FontWeight.bold, fontSize: 10.sp),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String key) {
    Widget screen;

    switch (key) {
      case AppLocalKay.new_class:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const UploadLessonScreen(),
        );
        break;
      case AppLocalKay.check_in:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const RecordingAbsenceScreen(),
        );
        break;
      case AppLocalKay.create_todo:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const CreateAssignmentScreen(),
        );
        break;
      case AppLocalKay.digital_library:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const TeacherDigitalLibraryScreen(),
        );
        break;
      case AppLocalKay.schedule:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const TeacherFullScheduleScreen(),
        );
        break;
      case AppLocalKay.grades:
        screen = BlocProvider(
          create: (context) => sl<HomeCubit>(),
          child: const TeacherGradesExamsScreen(),
        );
        break;
      default:
        screen = const UploadLessonScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
