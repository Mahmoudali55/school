import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/print_helper.dart';
import 'package:my_template/features/home/presentation/cubit/ai_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/ai_state.dart';
import 'package:share_plus/share_plus.dart';

class GenerateLessonIdeasScreen extends StatefulWidget {
  const GenerateLessonIdeasScreen({super.key});

  @override
  State<GenerateLessonIdeasScreen> createState() => _GenerateLessonIdeasScreenState();
}

class _GenerateLessonIdeasScreenState extends State<GenerateLessonIdeasScreen> {
  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  final _gradeLevelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _gradeLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: AppBar(
        title: Text(
          AppLocalKay.generate_button.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AICubit, AIState>(
        listenWhen: (previous, current) => previous.lessonIdeasStatus != current.lessonIdeasStatus,
        listener: (context, state) {
          if (state.lessonIdeasStatus.isSuccess) {
            _showResultBottomSheet(context, state.lessonIdeasStatus.data ?? '');
          }
        },
        child: BlocBuilder<AICubit, AIState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoCard(),
                    Gap(20.h),
                    _buildInputField(
                      controller: _subjectController,
                      label: AppLocalKay.subject_label.tr(),
                      hint: AppLocalKay.subject_hint.tr(),
                      icon: Icons.book_outlined,
                    ),
                    Gap(15.h),
                    _buildInputField(
                      controller: _topicController,
                      label: AppLocalKay.topic_label.tr(),
                      hint: AppLocalKay.topic_hint.tr(),
                      icon: Icons.topic_outlined,
                    ),
                    Gap(15.h),
                    _buildInputField(
                      controller: _gradeLevelController,
                      label: AppLocalKay.grade_level_label.tr(),
                      hint: AppLocalKay.grade_level_hint.tr(),
                      icon: Icons.school_outlined,
                    ),
                    Gap(25.h),
                    _buildGenerateButton(state),
                    Gap(20.h),
                    _buildResultLoaderOrError(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showResultBottomSheet(BuildContext context, String ideas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 0.8.sh,
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(25.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.greyColor(context).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppColor.accentColor(context), size: 24.w),
                        Gap(10.w),
                        Text(
                          AppLocalKay.results_header.tr(),
                          style: AppTextStyle.titleMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor(context),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: ideas));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalKay.copy_success.tr()),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.copy_rounded,
                            color: AppColor.grey600Color(context),
                            size: 22.w,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Share.share(ideas),
                          icon: Icon(
                            Icons.share_rounded,
                            color: AppColor.grey600Color(context),
                            size: 22.w,
                          ),
                        ),
                        IconButton(
                          onPressed: () => PrintHelper.printDocument(
                            title: AppLocalKay.results_header.tr(),
                            content: ideas,
                          ),
                          icon: Icon(
                            Icons.print_rounded,
                            color: AppColor.grey600Color(context),
                            size: 22.w,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: MarkdownBody(
                    data: ideas,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.black87, height: 1.5),
                      h2: AppTextStyle.titleMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.black87, height: 1.5),
                      p: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: Colors.black87, height: 1.6, fontSize: 16.sp),
                      listBullet: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.accentColor(context), fontWeight: FontWeight.bold),
                      strong: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColor.blackColor(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.accentColor(context).withValues(alpha: 0.1),
            AppColor.accentColor(context).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColor.accentColor(context).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: AppColor.accentColor(context), size: 30.w),
          Gap(12.w),
          Expanded(
            child: Text(
              AppLocalKay.lesson_ideas_info_card.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.grey600Color(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600)),
        Gap(8.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColor.primaryColor(context)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColor.greyColor(context).withValues(alpha: (0.2))),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColor.greyColor(context).withValues(alpha: (0.2))),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColor.primaryColor(context), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenerateButton(AIState state) {
    final isLoading = state.lessonIdeasStatus.isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                context.read<AICubit>().generateLessonIdeas(
                  subject: _subjectController.text.trim(),
                  topic: _topicController.text.trim(),
                  gradeLevel: _gradeLevelController.text.trim(),
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor(context),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.whiteColor(context)),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, color: AppColor.whiteColor(context)),
                Gap(8.w),
                Text(
                  AppLocalKay.generate_button.tr(),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildResultLoaderOrError(AIState state) {
    if (state.lessonIdeasStatus.isLoading) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColor.accentColor(context)),
            Gap(10.h),
            Text(
              AppLocalKay.loading_message.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.grey600Color(context)),
            ),
          ],
        ),
      );
    }

    if (state.lessonIdeasStatus.isFailure) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.errorColor(context).withValues(alpha: (0.05)),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColor.errorColor(context).withValues(alpha: (0.2))),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColor.errorColor(context), size: 24.w),
            Gap(12.w),
            Expanded(
              child: Text(
                '${AppLocalKay.error_message.tr()} ${state.lessonIdeasStatus.error}',
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.errorColor(context)),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
