import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/action_card_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<QuickAction> actions = [
      QuickAction(
        key: AppLocalKay.new_class,
        title: AppLocalKay.new_class.tr(),
        icon: Icons.upload,
        color: AppColor.primaryColor(context),
      ),
      QuickAction(
        key: AppLocalKay.check_in,
        title: AppLocalKay.check_in.tr(),
        icon: Icons.people,
        color: AppColor.secondAppColor(context),
      ),
      QuickAction(
        key: AppLocalKay.create_todo,
        title: AppLocalKay.create_todo.tr(),
        icon: Icons.assignment,
        color: AppColor.accentColor(context),
      ),
      QuickAction(
        key: AppLocalKay.digital_library,
        title: AppLocalKay.digital_library.tr(),
        icon: Icons.library_books_rounded,
        color: const Color(0xFF10B981), // Emerald/Clean
      ),
      QuickAction(
        key: AppLocalKay.schedule,
        title: AppLocalKay.full_schedule_teacher.tr(),
        icon: Icons.calendar_today,
        color: AppColor.errorColor(context),
      ),
      QuickAction(
        key: AppLocalKay.grades,
        title: AppLocalKay.grades_exams_teacher.tr(),
        icon: Icons.grade,
        color: const Color(0xFF7C3AED),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quick_actions.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.85,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return ActionCardWidget(action: actions[index]);
          },
        ),
      ],
    );
  }
}
