import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/services/file_viewer_utils.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/lesson_item_model.dart';
import 'package:my_template/features/home/data/models/add_lessons_request_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class UploadLessonScreen extends StatefulWidget {
  final LessonItemModel? lesson;
  const UploadLessonScreen({super.key, this.lesson});

  @override
  State<UploadLessonScreen> createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _submitted = false;
  int? _selectedLevelCode;
  int? _selectedClassCode;
  int? _selectedSubjectCode;
  DateTime? _dueDate;
  String? _uploadedFileUrl;
  String? _fileName;

  bool get isEdit => widget.lesson != null;
  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final lesson = widget.lesson!;
      _titleController.text = lesson.lesson;
      _notesController.text = lesson.notes;
      _uploadedFileUrl = lesson.lessonPath;
      if (lesson.lessonPath != null && lesson.lessonPath!.isNotEmpty) {
        _fileName = lesson.lessonPath!.split('/').last;
      }

      _dateController.text = lesson.lessonDate;
      try {
        _dueDate = DateFormat('yyyy-MM-dd').parse(lesson.lessonDate.split(' ').first);
      } catch (e) {
        _dueDate = DateTime.now();
      }

      _selectedLevelCode = lesson.levelCode;
      _selectedClassCode = lesson.classCode;
      _selectedSubjectCode = lesson.courseCode;
    }

    final stageStr = HiveMethods.getUserStage();
    if (stageStr != null && stageStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherLevel(int.parse(stageStr.toString()));
    }
    final userCodeStr = HiveMethods.getUserCode();
    if (userCodeStr != null && userCodeStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherCourses(int.parse(userCodeStr.toString()));
    }

    if (isEdit && _selectedLevelCode != null) {
      context.read<HomeCubit>().teacherClasses(
        int.parse(HiveMethods.getUserSection().toString()),
        int.parse(HiveMethods.getUserStage().toString()),
        _selectedLevelCode!,
      );
    }
    context.read<HomeCubit>().resetAddLessonsStatus();
    context.read<HomeCubit>().resetEditLessonsStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          isEdit ? AppLocalKay.edit.tr() : AppLocalKay.new_class.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final levels = state.teacherLevelStatus.data ?? [];
          final classesList = state.teacherClassesStatus.data ?? [];
          final courses = state.teacherCoursesStatus.data ?? [];

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state.addLessonsStatus.isSuccess || state.editLessonsStatus.isSuccess) {
                  CommonMethods.showToast(
                    message: state.addLessonsStatus.isSuccess
                        ? (state.addLessonsStatus.data?.msg ?? "")
                        : (state.editLessonsStatus.data?.msg ?? ""),
                  );
                  Navigator.pop(context, true);
                }
                if (state.addLessonsStatus.isFailure || state.editLessonsStatus.isFailure) {
                  CommonMethods.showToast(
                    message: state.addLessonsStatus.isFailure
                        ? (state.addLessonsStatus.error ?? "")
                        : (state.editLessonsStatus.error ?? ""),
                  );
                }
                if (state.uploadedFilesStatus?.isSuccess ?? false) {
                  setState(() {
                    _uploadedFileUrl = state.uploadedFilesStatus?.data?.first;
                  });
                  CommonMethods.showToast(message: AppLocalKay.file_uploaded.tr());
                }
                if (state.uploadedFilesStatus?.isFailure ?? false) {
                  CommonMethods.showToast(message: state.uploadedFilesStatus?.error ?? "");
                }
                if (state.imageFileNameStatus.isSuccess && _uploadedFileUrl != null) {
                  FileViewerUtils.displayFile(
                    context,
                    state.imageFileNameStatus.data!,
                    _uploadedFileUrl!,
                  );
                  context.read<HomeCubit>().resetImageFileNameStatus();
                }
                if (state.imageFileNameStatus.isFailure) {
                  CommonMethods.showToast(
                    message: state.imageFileNameStatus.error ?? "",
                    type: ToastType.error,
                  );
                  context.read<HomeCubit>().resetImageFileNameStatus();
                }
              },
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    /// القسم والمرحلة
                    Text(
                      AppLocalKay.user_management_class.tr(),
                      style: AppTextStyle.formTitleStyle(context),
                    ),
                    SizedBox(height: 8.h),
                    CustomDropdownFormField<int>(
                      value: levels.any((e) => e.levelCode == _selectedLevelCode)
                          ? _selectedLevelCode
                          : null,
                      submitted: _submitted,
                      hint: AppLocalKay.user_management_class.tr(),
                      errorText: AppLocalKay.user_management_select_class.tr(),
                      items: levels
                          .map(
                            (e) => DropdownMenuItem(value: e.levelCode, child: Text(e.levelName)),
                          )
                          .toList(),
                      onChanged: isEdit
                          ? null
                          : (v) {
                              setState(() {
                                _selectedLevelCode = v;
                                _selectedClassCode = null;
                              });
                              if (v != null) {
                                context.read<HomeCubit>().teacherClasses(
                                  int.parse(HiveMethods.getUserSection().toString()),
                                  int.parse(HiveMethods.getUserStage().toString()),
                                  v,
                                );
                              }
                            },
                    ),

                    Gap(16.h),

                    /// الشعبة
                    Text(
                      AppLocalKay.class_name_assigment.tr(),
                      style: AppTextStyle.formTitleStyle(context),
                    ),
                    SizedBox(height: 8.h),
                    CustomDropdownFormField<int>(
                      value: classesList.any((e) => e.classCode == _selectedClassCode)
                          ? _selectedClassCode
                          : null,
                      submitted: _submitted,
                      hint: AppLocalKay.class_name_assigment.tr(),
                      errorText: AppLocalKay.user_management_select_classs.tr(),
                      items: classesList
                          .map(
                            (e) => DropdownMenuItem(value: e.classCode, child: Text(e.classNameAr)),
                          )
                          .toList(),
                      onChanged: isEdit ? null : (v) => setState(() => _selectedClassCode = v),
                    ),

                    Gap(16.h),

                    // المادة
                    Text(
                      AppLocalKay.user_management_subject.tr(),
                      style: AppTextStyle.formTitleStyle(context),
                    ),
                    SizedBox(height: 8.h),
                    IgnorePointer(
                      ignoring: isEdit,
                      child: Opacity(
                        opacity: isEdit ? 0.5 : 1,
                        child: CustomDropdownFormField<int>(
                          value: courses.any((e) => e.courseCode == _selectedSubjectCode)
                              ? _selectedSubjectCode
                              : null,
                          submitted: _submitted,
                          hint: AppLocalKay.user_management_subject.tr(),
                          errorText: AppLocalKay.user_management_select_subject.tr(),
                          items: courses
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.courseCode,
                                  child: Text(e.courseName),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedSubjectCode = v),
                        ),
                      ),
                    ),
                    Gap(16.h),
                    CustomFormField(
                      readOnly: true,
                      radius: 12,
                      title: AppLocalKay.date_lesson.tr(),
                      controller: _dateController,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: isEdit ? null : _selectDueDate,
                      ),
                      onTap: isEdit ? null : _selectDueDate,
                      validator: (_) {
                        if (_dueDate == null) {
                          return AppLocalKay.user_management_no_deadline_lesson.tr();
                        }
                        return null;
                      },
                    ),
                    Gap(16.h),
                    CustomFormField(
                      controller: _titleController,
                      maxLines: 4,
                      title: AppLocalKay.class_description.tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalKay.user_management_select_description_lesson.tr();
                        }
                        return null;
                      },
                      radius: 12.r,
                    ),
                    Gap(16.h),
                    CustomFormField(
                      controller: _notesController,
                      title: AppLocalKay.note.tr(),
                      radius: 12.r,
                    ),
                    Gap(10.h),
                    GestureDetector(
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'mp4', 'avi'],
                        );

                        if (result != null && result.files.single.path != null) {
                          setState(() {
                            _fileName = result.files.single.name;
                          });
                          if (context.mounted) {
                            context.read<HomeCubit>().uploadFiles([result.files.single.path!]);
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
                                  CustomLoading(color: AppColor.accentColor(context), size: 30.w),
                                  SizedBox(height: 8.h),
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
                                  SizedBox(height: 8.h),
                                  Text(
                                    _fileName ?? AppLocalKay.user_management_upload_lesson.tr(),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.titleMedium(
                                      context,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.h),
                                  if (_uploadedFileUrl != null && _uploadedFileUrl!.isNotEmpty) ...[
                                    Gap(12.h),
                                    CustomButton(
                                      radius: 12.r,
                                      onPressed: () {
                                        context.read<HomeCubit>().imageFileName(_uploadedFileUrl!);
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
                                              style: AppTextStyle.titleLarge(
                                                context,
                                              ).copyWith(color: AppColor.whiteColor(context)),
                                            ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// زر الرفع
                    CustomButton(
                      radius: 12.r,
                      child: (state.addLessonsStatus.isLoading || state.editLessonsStatus.isLoading)
                          ? CustomLoading(color: AppColor.whiteColor(context), size: 15.w)
                          : Text(
                              isEdit
                                  ? AppLocalKay.edit.tr()
                                  : AppLocalKay.user_management_create_lesson.tr(),
                              style: AppTextStyle.titleLarge(
                                context,
                              ).copyWith(color: AppColor.whiteColor(context)),
                            ),
                      color: AppColor.accentColor(context),
                      onPressed: () {
                        setState(() => _submitted = true);
                        if (_formKey.currentState!.validate()) {
                          final request = AddLessonsRequestModel(
                            id: isEdit ? widget.lesson!.id.toString() : "",
                            sectionCode: int.parse(HiveMethods.getUserSection()),
                            stageCode: int.parse(HiveMethods.getUserStage()),
                            levelCode: _selectedLevelCode!,
                            classCode: _selectedClassCode!,
                            lesson: _titleController.text,
                            lessonPath: _uploadedFileUrl ?? "",
                            lessonDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
                            teacherCode: int.parse(HiveMethods.getUserCode()),
                            notes: _notesController.text,
                            CourseCode: _selectedSubjectCode!,
                          );

                          if (isEdit) {
                            context.read<HomeCubit>().editLessons(request: request);
                          } else {
                            context.read<HomeCubit>().addLessons(request: request);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
