import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/ai_cubit.dart';
import 'package:my_template/features/home/presentation/view/screen/generate_quiz_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/summarize_notes_screen.dart';

class StudentAIAssistantScreen extends StatelessWidget {
  const StudentAIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          AppLocalKay.student_ai_assistant.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Gap(25.h),
            _buildActionCard(
              context,
              title: AppLocalKay.summarize_lesson_title.tr(),
              subtitle: AppLocalKay.summarize_lesson_subtitle.tr(),
              icon: Icons.summarize_outlined,
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => sl<AICubit>(),
                      child: const SummarizeNotesScreen(),
                    ),
                  ),
                );
              },
            ),
            Gap(15.h),
            _buildActionCard(
              context,
              title: AppLocalKay.study_practice_title.tr(),
              subtitle: AppLocalKay.study_practice_subtitle.tr(),
              icon: Icons.quiz_outlined,
              color: const Color(0xFF3B82F6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => sl<AICubit>(),
                      child: const GenerateQuizScreen(),
                    ),
                  ),
                );
              },
            ),
            Gap(30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context),
            AppColor.primaryColor(context).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor(context).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.ai_welcome_title.tr(),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context)),
                ),
                Gap(8.h),
                Text(
                  AppLocalKay.student_ai_welcome_subtitle.tr(),
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context).withValues(alpha: (0.9))),
                ),
              ],
            ),
          ),
          Icon(
            Icons.auto_awesome,
            size: 50.w,
            color: AppColor.whiteColor(context).withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColor.greyColor(context).withValues(alpha: (0.1))),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor(context).withValues(alpha: (0.02)),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: (0.1)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 28.w),
            ),
            Gap(15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(4.h),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.grey600Color(context)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.w, color: AppColor.grey400Color(context)),
          ],
        ),
      ),
    );
  }
}
