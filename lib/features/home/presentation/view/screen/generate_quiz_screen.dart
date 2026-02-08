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

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  State<GenerateQuizScreen> createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  final _questionCountController = TextEditingController(text: '5');
  int _selectedQuizTypeIndex = 0;
  final _formKey = GlobalKey<FormState>();

  List<String> get _quizTypes => [
    AppLocalKay.multiple_choice.tr(),
    AppLocalKay.true_false.tr(),
    AppLocalKay.mixed.tr(),
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _questionCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          AppLocalKay.generate_quiz_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AICubit, AIState>(
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
                    hint: AppLocalKay.quiz_subject_hint.tr(),
                    icon: Icons.book_outlined,
                  ),
                  Gap(15.h),
                  _buildInputField(
                    controller: _topicController,
                    label: AppLocalKay.topic_label.tr(),
                    hint: AppLocalKay.quiz_topic_hint.tr(),
                    icon: Icons.topic_outlined,
                  ),
                  Gap(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _questionCountController,
                          label: AppLocalKay.number_of_questions_label.tr(),
                          hint: '5',
                          icon: Icons.numbers,
                          isNumber: true,
                        ),
                      ),
                      Gap(15.w),
                      Expanded(
                        child: _buildDropdownField(
                          label: AppLocalKay.question_type_label.tr(),
                          value: _quizTypes[_selectedQuizTypeIndex],
                          items: _quizTypes,
                          onChanged: (value) {
                            setState(() {
                              _selectedQuizTypeIndex = _quizTypes.indexOf(value!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(25.h),
                  _buildGenerateButton(state),
                  Gap(20.h),
                  _buildResultSection(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.quiz, color: const Color(0xFF3B82F6), size: 30.w),
          Gap(12.w),
          Expanded(
            child: Text(
              AppLocalKay.quiz_info_card.tr(),
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
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600)),
        Gap(8.h),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
            if (isNumber && int.tryParse(value) == null) {
              return AppLocalKay.invalid_number.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600)),
        Gap(8.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: AppTextStyle.bodyMedium(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.whiteColor(context),
            prefixIcon: Icon(Icons.category, color: AppColor.primaryColor(context)),
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
        ),
      ],
    );
  }

  Widget _buildGenerateButton(AIState state) {
    final isLoading = state.quizStatus.isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                context.read<AICubit>().generateQuiz(
                  subject: _subjectController.text.trim(),
                  topic: _topicController.text.trim(),
                  numberOfQuestions: int.parse(_questionCountController.text.trim()),
                  questionType: _quizTypes[_selectedQuizTypeIndex],
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
                  AppLocalKay.generate_quiz_button.tr(),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildResultSection(AIState state) {
    if (state.quizStatus.isLoading) {
      return Container(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.only(top: 20.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColor.infoColor(context)),
            Gap(10.h),
            Text(
              AppLocalKay.generating_quiz_loading.tr(),
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(color: AppColor.grey600Color(context)),
            ),
          ],
        ),
      );
    }

    if (state.quizStatus.isSuccess) {
      final quiz = state.quizStatus.data ?? '';
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.infoColor(context).withValues(alpha: (0.1)),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: AppColor.infoColor(context).withValues(alpha: (0.1))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.infoColor(context).withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                border: Border(
                  bottom: BorderSide(color: AppColor.infoColor(context).withValues(alpha: (0.1))),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.quiz_outlined, color: AppColor.infoColor(context), size: 22.w),
                      Gap(8.w),
                      Text(
                        AppLocalKay.quiz_result_header.tr(),
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: quiz));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalKay.copy_quiz_success.tr(),
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(color: AppColor.whiteColor(context)),
                              ),
                              backgroundColor: AppColor.secondAppColor(context),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          color: AppColor.grey600Color(context),
                          size: 20.w,
                        ),
                        tooltip: AppLocalKay.copy.tr(),
                      ),
                      IconButton(
                        onPressed: () => SharePlus.instance.share(ShareParams(text: quiz)),
                        icon: Icon(
                          Icons.share_rounded,
                          color: AppColor.grey600Color(context),
                          size: 20.w,
                        ),
                        tooltip: AppLocalKay.share.tr(),
                      ),
                      IconButton(
                        onPressed: () => PrintHelper.printDocument(
                          title: AppLocalKay.quiz_result_header.tr(),
                          content: quiz,
                        ),
                        icon: Icon(
                          Icons.print_rounded,
                          color: AppColor.grey600Color(context),
                          size: 20.w,
                        ),
                        tooltip: AppLocalKay.print.tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: MarkdownBody(
                data: quiz,
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
                  ).copyWith(color: AppColor.blackColor(context), height: 1.6, fontSize: 16.sp),
                  listBullet: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: const Color(0xFF3B82F6), fontWeight: FontWeight.bold),
                  strong: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (state.quizStatus.isFailure) {
      return Container(
        margin: EdgeInsets.only(top: 20.h),
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
                '${AppLocalKay.error_message.tr()}: ${state.quizStatus.error}',
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
