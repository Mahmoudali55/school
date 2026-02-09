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

class SummarizeNotesScreen extends StatefulWidget {
  const SummarizeNotesScreen({super.key});

  @override
  State<SummarizeNotesScreen> createState() => _SummarizeNotesScreenState();
}

class _SummarizeNotesScreenState extends State<SummarizeNotesScreen> {
  final _subjectController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          AppLocalKay.summarize_notes_title.tr(),
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
      body: BlocListener<AICubit, AIState>(
        listenWhen: (previous, current) => previous.summaryStatus != current.summaryStatus,
        listener: (context, state) {
          if (state.summaryStatus.isSuccess) {
            _showSummaryResultBottomSheet(context, state.summaryStatus.data ?? '');
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
                      hint: AppLocalKay.summarize_subject_hint.tr(),
                      icon: Icons.book_outlined,
                      maxLines: 1,
                    ),
                    Gap(15.h),
                    _buildInputField(
                      controller: _notesController,
                      label: AppLocalKay.notes_label.tr(),
                      hint: AppLocalKay.notes_hint.tr(),
                      icon: Icons.note_outlined,
                      maxLines: 10,
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

  void _showSummaryResultBottomSheet(BuildContext context, String summary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 0.85.sh,
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
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppColor.secondAppColor(context).withValues(alpha: (0.1)),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.summarize_outlined,
                            color: AppColor.secondAppColor(context),
                            size: 20.w,
                          ),
                        ),
                        Gap(10.w),
                        Text(
                          AppLocalKay.summary_result_header.tr(),
                          style: AppTextStyle.titleMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor(context),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildBottomSheetActionButton(
                          icon: Icons.copy_rounded,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: summary));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalKay.copy_success.tr()),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          tooltip: AppLocalKay.copy.tr(),
                        ),
                        Gap(8.w),
                        _buildBottomSheetActionButton(
                          icon: Icons.share_rounded,
                          onTap: () => Share.share(summary),
                          tooltip: AppLocalKay.share.tr(),
                        ),
                        Gap(8.w),
                        _buildBottomSheetActionButton(
                          icon: Icons.print_rounded,
                          onTap: () => PrintHelper.printDocument(
                            title: AppLocalKay.summary_result_header.tr(),
                            content: summary,
                          ),
                          tooltip: AppLocalKay.print.tr(),
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
                    data: summary,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: AppTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackColor(context),
                        height: 1.8,
                      ),
                      h2: AppTextStyle.titleMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackColor(context),
                        height: 1.8,
                      ),
                      p: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColor.blackColor(context).withValues(alpha: 0.8),
                        height: 1.8,
                        fontSize: 15.sp,
                      ),
                      listBullet: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColor.secondAppColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                      strong: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
                      blockSpacing: 15.h,
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

  Widget _buildBottomSheetActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.greyColor(context).withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColor.grey600Color(context), size: 18.w),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.1),
            const Color(0xFF10B981).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.summarize, color: const Color(0xFF10B981), size: 30.w),
          Gap(12.w),
          Expanded(
            child: Text(
              AppLocalKay.summarize_notes_info_card.tr(),
              style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[700]),
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
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600)),
        Gap(8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: maxLines == 1
                ? Icon(icon, color: AppColor.primaryColor(context))
                : Padding(
                    padding: EdgeInsets.only(bottom: (maxLines - 1) * 20.0),
                    child: Icon(icon, color: AppColor.primaryColor(context)),
                  ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withAlpha(51)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withAlpha(51)),
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
            if (label == 'الملاحظات' && value.trim().length < 1) {
              // Adjusted validation
              return AppLocalKay.notes_validation_error.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenerateButton(AIState state) {
    final isLoading = state.summaryStatus.isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                context.read<AICubit>().summarizeNotes(
                  subject: _subjectController.text.trim(),
                  notes: _notesController.text.trim(),
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10B981),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white),
                Gap(8.w),
                Text(
                  AppLocalKay.summarize_button.tr(),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildResultLoaderOrError(AIState state) {
    if (state.summaryStatus.isLoading) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Color(0xFF10B981)),
            Gap(10.h),
            Text(
              AppLocalKay.generating_summary_loading.tr(),
              style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (state.summaryStatus.isFailure) {
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
                '${AppLocalKay.error_message.tr()}: ${state.summaryStatus.error}',
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
