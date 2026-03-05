import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TeacherDigitalLibraryScreen extends StatefulWidget {
  const TeacherDigitalLibraryScreen({super.key});

  @override
  State<TeacherDigitalLibraryScreen> createState() => _TeacherDigitalLibraryScreenState();
}

class _TeacherDigitalLibraryScreenState extends State<TeacherDigitalLibraryScreen> {
  String _selectedCategory = "all";
  String? _uploadedFileUrl;
  String? _fileName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadBottomSheet,
        backgroundColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Icon(Icons.add_rounded, color: AppColor.whiteColor(context)),
      ),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.digital_library.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildResourcesList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن كتب، فيديوهات، أو ملخصات...",
                  hintStyle: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                  border: InputBorder.none,
                  icon: Icon(Icons.search_rounded, color: AppColor.greyColor(context)),
                ),
              ),
            ),
          ),
          Gap(20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip("all", "الكل", Icons.grid_view_rounded),
                _buildCategoryChip("books", "الكتب", Icons.book_rounded),
                _buildCategoryChip("videos", "الفيديوهات", Icons.play_circle_fill_rounded),
                _buildCategoryChip("files", "الملفات", Icons.description_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    bool isSelected = _selectedCategory == id;
    return FadeInRight(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = id),
        child: Container(
          margin: EdgeInsets.only(left: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.w,
                color: isSelected ? Colors.white : AppColor.greyColor(context),
              ),
              Gap(8.w),
              Text(
                label,
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColor.blackColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesList() {
    return ListView(
      padding: EdgeInsets.all(20.w),
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            "المصادر الحديثة",
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Gap(16.h),
        _buildResourceCard(
          "كتاب الرياضيات - المستوى الثالث",
          "PDF • 12.5 MB",
          Icons.picture_as_pdf_rounded,
          Colors.redAccent,
          200,
        ),
        _buildResourceCard(
          "شرح الوحدة الخامسة (فيديو)",
          "MP4 • 45:12",
          Icons.play_circle_outline_rounded,
          Colors.blueAccent,
          400,
        ),
        _buildResourceCard(
          "ملخص قوانين الفيزياء",
          "DOCX • 2.1 MB",
          Icons.article_rounded,
          Colors.indigoAccent,
          600,
        ),
        _buildResourceCard(
          "خطة الفصل الدراسي الثاني",
          "PDF • 1.2 MB",
          Icons.picture_as_pdf_rounded,
          Colors.redAccent,
          800,
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String info, IconData icon, Color color, int delay) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: delay),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(4.h),
                  Text(
                    info,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.greyColor(context)),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
              color: AppColor.greyColor(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadBottomSheet() {
    String? title;
    String? category = "books";
    List<String> filePaths = [];
    bool submitted = false;
    final formKey = GlobalKey<FormState>();
    _uploadedFileUrl = null;
    _fileName = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<HomeCubit>(),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state.uploadedFilesStatus?.isSuccess ?? false) {
                      setState(() {
                        _uploadedFileUrl = state.uploadedFilesStatus?.data?.first;
                      });
                      CommonMethods.showToast(message: AppLocalKay.file_uploaded.tr());
                      context.read<HomeCubit>().resetUploadedFilesStatus();
                    } else if (state.uploadedFilesStatus?.isFailure ?? false) {
                      CommonMethods.showToast(
                        message: state.uploadedFilesStatus?.error ?? "",
                        type: ToastType.error,
                      );
                      context.read<HomeCubit>().resetUploadedFilesStatus();
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalKay.digital_library_upload.tr(),
                              style: AppTextStyle.titleMedium(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            Gap(20.h),
                            Text(
                              AppLocalKay.file_name.tr(),
                              style: AppTextStyle.formTitleStyle(context),
                            ),
                            Gap(8.h),
                            CustomFormField(
                              hintText: AppLocalKay.enter_file_name.tr(),
                              validator: (v) =>
                                  v!.isEmpty ? AppLocalKay.enter_file_name.tr() : null,

                              onChanged: (v) => title = v,
                            ),
                            Gap(16.h),
                            Text(
                              AppLocalKay.file_type.tr(),
                              style: AppTextStyle.formTitleStyle(context),
                            ),
                            Gap(8.h),
                            CustomDropdownFormField<String>(
                              errorText: '',

                              hint: AppLocalKay.file_type.tr(),

                              value: category,
                              items: [
                                DropdownMenuItem(
                                  value: "books",
                                  child: Text(AppLocalKay.books.tr()),
                                ),
                                DropdownMenuItem(
                                  value: "videos",
                                  child: Text(AppLocalKay.videos.tr()),
                                ),
                                DropdownMenuItem(
                                  value: "files",
                                  child: Text(AppLocalKay.worksheets.tr()),
                                ),
                              ],
                              onChanged: (v) => setModalState(() => category = v),
                              submitted: submitted,
                            ),
                            Gap(16.h),
                            Text(
                              AppLocalKay.upload_file.tr(),
                              style: AppTextStyle.formTitleStyle(context),
                            ),
                            Gap(8.h),
                            GestureDetector(
                              onTap: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'pdf',
                                    'ppt',
                                    'pptx',
                                    'doc',
                                    'docx',
                                    'mp4',
                                    'avi',
                                  ],
                                );

                                if (result != null && result.files.single.path != null) {
                                  setState(() {
                                    _fileName = result.files.single.name;
                                  });
                                  if (context.mounted) {
                                    context.read<HomeCubit>().uploadFiles([
                                      result.files.single.path!,
                                    ]);
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: state.uploadedFilesStatus?.isLoading ?? false
                                    ? Column(
                                        children: [
                                          CustomLoading(
                                            color: AppColor.accentColor(context),
                                            size: 30.w,
                                          ),
                                          Gap(8.h),
                                          Text(AppLocalKay.loading.tr()),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Icon(
                                            _uploadedFileUrl != null
                                                ? Icons.check_circle
                                                : Icons.cloud_upload,
                                            size: 40.w,
                                            color: _uploadedFileUrl != null
                                                ? AppColor.secondAppColor(context)
                                                : AppColor.greyColor(context),
                                          ),
                                          Gap(8.h),
                                          Text(
                                            _fileName ?? AppLocalKay.choose_file.tr(),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.titleMedium(
                                              context,
                                            ).copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          Gap(8.h),
                                          if (_uploadedFileUrl != null &&
                                              _uploadedFileUrl!.isNotEmpty) ...[
                                            Gap(12.h),
                                            CustomButton(
                                              radius: 12.r,
                                              onPressed: () {
                                                context.read<HomeCubit>().imageFileName(
                                                  _uploadedFileUrl!,
                                                );
                                              },
                                              child:
                                                  context
                                                          .watch<HomeCubit>()
                                                          .state
                                                          .imageFileNameStatus
                                                          ?.isLoading ??
                                                      false
                                                  ? CustomLoading(
                                                      color: AppColor.whiteColor(context),
                                                      size: 15.w,
                                                    )
                                                  : Text(
                                                      AppLocalKay.display.tr(),
                                                      style: AppTextStyle.titleLarge(context)
                                                          .copyWith(
                                                            color: AppColor.whiteColor(context),
                                                          ),
                                                    ),
                                            ),
                                          ],
                                        ],
                                      ),
                              ),
                            ),
                            if (submitted && _uploadedFileUrl == null)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  AppLocalKay.required.tr(),
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(color: Colors.red),
                                ),
                              ),
                            Gap(32.h),

                            CustomButton(
                              radius: 12.r,
                              color: AppColor.secondAppColor(context),
                              child: Text(
                                AppLocalKay.save.tr(),
                                style: AppTextStyle.bodyLarge(context, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                setModalState(() => submitted = true);
                                if (formKey.currentState!.validate() && _uploadedFileUrl != null) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            Gap(32.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
