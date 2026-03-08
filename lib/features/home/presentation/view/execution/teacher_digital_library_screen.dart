import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/add_digital_library_model.dart';
import 'package:my_template/features/home/data/models/get_digital_library_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/execution/library_item_detail_screen.dart';

class TeacherDigitalLibraryScreen extends StatefulWidget {
  const TeacherDigitalLibraryScreen({super.key});

  @override
  State<TeacherDigitalLibraryScreen> createState() => _TeacherDigitalLibraryScreenState();
}

class _TeacherDigitalLibraryScreenState extends State<TeacherDigitalLibraryScreen> {
  String? _uploadedFileUrl;
  String? _fileName;
  int? _selectedLevelCode;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Default load level 111 as requested by user manual edit
      _selectedLevelCode = 111;
      context.read<HomeCubit>().getDigitalLibrary(levelCode: 111);

      // Load teacher levels based on stageCode from Hive
      final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
      if (stageCode > 0) {
        context.read<HomeCubit>().teacherLevel(stageCode);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadBottomSheet,
        backgroundColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        tooltip: AppLocalKay.add.tr(),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 28.w),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.addDigitalLibraryStatus.isSuccess) {
            CommonMethods.showToast(
              message: state.addDigitalLibraryStatus.data?.msg ?? AppLocalKay.done.tr(),
            );
            context.read<HomeCubit>().resetAddDigitalLibraryStatus();
            if (_selectedLevelCode != null) {
              context.read<HomeCubit>().getDigitalLibrary(levelCode: _selectedLevelCode!);
            }
          } else if (state.addDigitalLibraryStatus.isFailure) {
            CommonMethods.showToast(
              message: state.addDigitalLibraryStatus.error ?? '',
              type: ToastType.error,
            );
            context.read<HomeCubit>().resetAddDigitalLibraryStatus();
          }
        },
        builder: (context, state) {
          final levels = state.teacherLevelStatus.data ?? [];
          final allItems = state.getDigitalLibraryStatus.data ?? [];
          final filteredItems = _searchQuery.isEmpty
              ? allItems
              : allItems
                    .where(
                      (e) =>
                          e.fileName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          e.teacherName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          e.notes.toLowerCase().contains(_searchQuery.toLowerCase()),
                    )
                    .toList();

          return Column(
            children: [
              // ── Modern Gradient Header ──
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    MediaQuery.of(context).padding.top + 10.h,
                    20.w,
                    20.h,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D9F6F), Color(0xFF10B981)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            padding: EdgeInsets.zero,
                          ),
                          Gap(8.w),
                          Text(
                            AppLocalKay.digital_library.tr(),
                            style: AppTextStyle.titleLarge(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.library_books_rounded,
                              color: Colors.white,
                              size: 20.w,
                            ),
                          ),
                        ],
                      ),
                      Gap(20.h),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'ابحث في المكتبة...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey.shade400,
                              size: 22.w,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 20),
                                    color: Colors.grey.shade400,
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                      Gap(12.h),
                      // Level Dropdown
                      Text(
                        AppLocalKay.select_level.tr(),
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Gap(8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedLevelCode,
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                            ),
                            hint: Text(
                              AppLocalKay.level.tr(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13.sp,
                              ),
                            ),
                            isExpanded: true,
                            items: levels
                                .map(
                                  (level) => DropdownMenuItem<int>(
                                    value: level.levelCode,
                                    child: Text(
                                      level.levelName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: _selectedLevelCode == level.levelCode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() => _selectedLevelCode = v);
                              if (v != null) {
                                context.read<HomeCubit>().getDigitalLibrary(levelCode: v);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Files List ──
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_selectedLevelCode == null) {
                      return FadeInUp(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_rounded,
                                size: 70.w,
                                color: Colors.grey.shade200,
                              ),
                              Gap(16.h),
                              Text(
                                'اختر الصف لعرض الملفات',
                                style: AppTextStyle.titleMedium(
                                  context,
                                ).copyWith(color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state.getDigitalLibraryStatus.isLoading) {
                      return Center(
                        child: CustomLoading(color: const Color(0xFF10B981), size: 40.w),
                      );
                    }
                    if (filteredItems.isEmpty) {
                      return FadeInUp(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 70.w,
                                color: Colors.grey.shade200,
                              ),
                              Gap(16.h),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'لا توجد نتائج للبحث'
                                    : 'لا توجد ملفات في هذا الصف',
                                style: AppTextStyle.titleMedium(
                                  context,
                                ).copyWith(color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 80.h),
                      itemCount: filteredItems.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildResourceCard(filteredItems[index], index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResourceCard(DigitalLibraryItem item, int index) {
    final ext = item.fileExtension;
    IconData icon;
    Color iconColor;
    Color cardAccent;

    if (['pdf'].contains(ext)) {
      icon = Icons.picture_as_pdf_rounded;
      iconColor = const Color(0xFFEF4444);
      cardAccent = const Color(0xFFEF4444);
    } else if (['mp4', 'avi', 'mov'].contains(ext)) {
      icon = Icons.play_circle_fill_rounded;
      iconColor = const Color(0xFF3B82F6);
      cardAccent = const Color(0xFF3B82F6);
    } else if (['doc', 'docx'].contains(ext)) {
      icon = Icons.article_rounded;
      iconColor = const Color(0xFF6366F1);
      cardAccent = const Color(0xFF6366F1);
    } else if (['ppt', 'pptx'].contains(ext)) {
      icon = Icons.slideshow_rounded;
      iconColor = const Color(0xFFF97316);
      cardAccent = const Color(0xFFF97316);
    } else if (['png', 'jpg', 'jpeg'].contains(ext)) {
      icon = Icons.image_rounded;
      iconColor = const Color(0xFF8B5CF6);
      cardAccent = const Color(0xFF8B5CF6);
    } else {
      icon = Icons.insert_drive_file_rounded;
      iconColor = const Color(0xFF10B981);
      cardAccent = const Color(0xFF10B981);
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      delay: Duration(milliseconds: index * 80),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: cardAccent.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            final homeCubit = context.read<HomeCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: homeCubit,
                  child: LibraryItemDetailScreen(item: item),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Colored left accent bar
                  Container(width: 5.w, color: cardAccent),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Row(
                        children: [
                          // File type icon circle
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Center(
                              child: Icon(icon, color: iconColor, size: 26.w),
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fileName,
                                  style: AppTextStyle.bodyLarge(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.teacherName.isNotEmpty) ...[
                                  Gap(3.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        size: 13.w,
                                        color: Colors.grey.shade500,
                                      ),
                                      Gap(4.w),
                                      Flexible(
                                        child: Text(
                                          item.teacherName,
                                          style: AppTextStyle.bodySmall(
                                            context,
                                          ).copyWith(color: Colors.grey.shade500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (item.notes.isNotEmpty) ...[
                                  Gap(3.h),
                                  Text(
                                    item.notes,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: Colors.grey.shade400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Extension badge
                          if (ext.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: cardAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                ext.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cardAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadBottomSheet() {
    String? title;
    String notes = "";
    int? selectedLevelCode;
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
                    }

                    if (state.addDigitalLibraryStatus.isSuccess) {
                      CommonMethods.showToast(
                        message: state.addDigitalLibraryStatus.data?.msg ?? AppLocalKay.done.tr(),
                      );
                      context.read<HomeCubit>().resetAddDigitalLibraryStatus();
                      Navigator.pop(context);
                    } else if (state.addDigitalLibraryStatus.isFailure) {
                      CommonMethods.showToast(
                        message: state.addDigitalLibraryStatus.error ?? "",
                        type: ToastType.error,
                      );
                      context.read<HomeCubit>().resetAddDigitalLibraryStatus();
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
                            // Level dropdown from teacherLevel API
                            Text(
                              AppLocalKay.student_grade.tr(),
                              style: AppTextStyle.formTitleStyle(context),
                            ),
                            Gap(8.h),
                            if (state.teacherLevelStatus.isLoading)
                              Center(
                                child: CustomLoading(
                                  color: AppColor.accentColor(context),
                                  size: 24.w,
                                ),
                              )
                            else
                              DropdownButtonFormField<int>(
                                value: selectedLevelCode,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  errorText: submitted && selectedLevelCode == null
                                      ? AppLocalKay.required.tr()
                                      : null,
                                ),
                                hint: Text(AppLocalKay.level.tr()),
                                items: [
                                  ...(state.teacherLevelStatus.data ?? []).map(
                                    (level) => DropdownMenuItem<int>(
                                      value: level.levelCode,
                                      child: Text(level.levelName),
                                    ),
                                  ),
                                ],
                                onChanged: (v) => setModalState(() => selectedLevelCode = v),
                                validator: (_) => null,
                              ),
                            Gap(16.h),
                            Text(
                              AppLocalKay.notes.tr(),
                              style: AppTextStyle.formTitleStyle(context),
                            ),
                            Gap(8.h),
                            CustomFormField(
                              hintText: AppLocalKay.notes.tr(),
                              onChanged: (v) => notes = v,
                              maxLines: 3,
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
                              child: state.addDigitalLibraryStatus.isLoading
                                  ? CustomLoading(color: AppColor.whiteColor(context), size: 20.w)
                                  : Text(
                                      AppLocalKay.save.tr(),
                                      style: AppTextStyle.bodyLarge(context, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),

                              onPressed: () {
                                setModalState(() => submitted = true);
                                if (formKey.currentState!.validate() && _uploadedFileUrl != null) {
                                  final teacherCode =
                                      int.tryParse(HiveMethods.getUserCode().toString()) ?? 0;

                                  if (selectedLevelCode == null) {
                                    setModalState(() {});
                                    return;
                                  }

                                  context.read<HomeCubit>().addDigitalLibrary(
                                    request: AddDigitalLibraryRequestModel(
                                      fileName: title ?? "",
                                      filepath: _uploadedFileUrl!,
                                      levelCode: selectedLevelCode!,
                                      teacherCode: teacherCode,
                                      notes: notes,
                                    ),
                                  );
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
