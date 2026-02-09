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
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/get_T_home_work_model.dart';
import 'package:my_template/features/home/data/models/add_home_work_request_model.dart';
import 'package:my_template/features/home/data/models/home_work_details_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class CreateAssignmentScreen extends StatefulWidget {
  final THomeWorkItem? homework;
  const CreateAssignmentScreen({super.key, this.homework});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;
  late final TextEditingController _dateController;
  bool _submitted = false;
  int? _selectedLevelCode;
  int? _selectedClassCode;
  int? _selectedSubjectCode;
  DateTime? _dueDate;
  String? _uploadedFileUrl;
  String? _fileName;
  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.homework?.hw ?? '');
    _notesController = TextEditingController(text: widget.homework?.notes ?? '');
    if (widget.homework == null) {
      _dateController = TextEditingController();
    }

    final stageStr = HiveMethods.getUserStage();
    if (stageStr != null && stageStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherLevel(int.parse(stageStr.toString()));
    }
    final userCodeStr = HiveMethods.getUserCode();
    if (userCodeStr != null && userCodeStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherCourses(int.parse(userCodeStr.toString()));
    }

    if (widget.homework != null) {
      _selectedLevelCode = widget.homework!.levelCode;
      _selectedClassCode = widget.homework!.classCode;
      _selectedSubjectCode = widget.homework!.courseCode;

      debugPrint("Incoming HW Date String: '${widget.homework!.hwDate}'");

      try {
        _dueDate = DateTime.tryParse(widget.homework!.hwDate);
        if (_dueDate == null) {
          // Try common formats
          try {
            _dueDate = DateFormat("yyyy-MM-dd").parse(widget.homework!.hwDate);
          } catch (_) {
            try {
              _dueDate = DateFormat("dd/MM/yyyy").parse(widget.homework!.hwDate);
            } catch (_) {
              // Try ISO with time
              try {
                _dueDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(widget.homework!.hwDate);
              } catch (e) {
                debugPrint("All date parsing failed. Keeping raw string.");
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }

      _dateController = TextEditingController(
        text: _dueDate != null
            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
            : (widget.homework?.hwDate ?? ''),
      );

      // Trigger classes fetch for the selected level
      context.read<HomeCubit>().teacherClasses(
        int.parse(HiveMethods.getUserSection().toString()),
        int.parse(HiveMethods.getUserStage().toString()),
        _selectedLevelCode!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.homework != null;
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          isEdit ? AppLocalKay.edit_task.tr() : AppLocalKay.create_todo.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.addHomeworkStatus.isSuccess) {
            CommonMethods.showToast(message: state.addHomeworkStatus.data?.msg ?? "");
            context.read<HomeCubit>().resetAddHomeworkStatus();
            Navigator.pop(context, true);
          } else if (state.addHomeworkStatus.isFailure) {
            CommonMethods.showToast(message: state.addHomeworkStatus.error ?? "");
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
        },
        builder: (context, state) {
          final levels = state.teacherLevelStatus.data ?? [];
          final classesList = state.teacherClassesStatus.data ?? [];
          final courses = state.teacherCoursesStatus.data ?? [];
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  /// القسم
                  Text(
                    AppLocalKay.user_management_class.tr(),
                    style: AppTextStyle.formTitleStyle(context),
                  ),
                  SizedBox(height: 8.h),
                  IgnorePointer(
                    ignoring: isEdit,
                    child: Opacity(
                      opacity: isEdit ? 0.5 : 1,
                      child: CustomDropdownFormField<int>(
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
                        onChanged: (v) {
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
                    ),
                  ),

                  Gap(8.h),

                  /// الشعبة
                  Text(
                    AppLocalKay.class_name_assigment.tr(),
                    style: AppTextStyle.formTitleStyle(context),
                  ),
                  SizedBox(height: 8.h),
                  IgnorePointer(
                    ignoring: isEdit,
                    child: Opacity(
                      opacity: isEdit ? 0.5 : 1,
                      child: CustomDropdownFormField<int>(
                        value: classesList.any((e) => e.classCode == _selectedClassCode)
                            ? _selectedClassCode
                            : null,
                        submitted: _submitted,
                        hint: AppLocalKay.class_name_assigment.tr(),
                        errorText: AppLocalKay.user_management_select_classs.tr(),
                        items: classesList
                            .map(
                              (e) =>
                                  DropdownMenuItem(value: e.classCode, child: Text(e.classNameAr)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedClassCode = v),
                      ),
                    ),
                  ),

                  Gap(8.h),

                  /// المادة
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
                              (e) =>
                                  DropdownMenuItem(value: e.courseCode, child: Text(e.courseName)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedSubjectCode = v),
                      ),
                    ),
                  ),

                  Gap(8.h),

                  /// تاريخ التسليم
                  IgnorePointer(
                    ignoring: isEdit, // يقفل فقط في حالة التعديل
                    child: Opacity(
                      opacity: isEdit ? 0.5 : 1,
                      child: CustomFormField(
                        readOnly: true,
                        radius: 12,
                        title: AppLocalKay.user_management_deadline.tr(),
                        controller: _dateController,

                        // 👇 الكاليندر يشتغل فقط في الإضافة
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: isEdit ? null : _selectDueDate,
                        ),

                        // 👇 نسمح بالضغط على الحقل نفسه في الإضافة
                        onTap: isEdit ? null : _selectDueDate,

                        validator: (_) {
                          if (_dueDate == null) {
                            return AppLocalKay.user_management_no_deadline.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  Gap(8.h),

                  /// الوصف
                  CustomFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    radius: 12,
                    title: AppLocalKay.user_management_description.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalKay.user_management_select_description.tr();
                      }
                      return null;
                    },
                  ),

                  Gap(8.h),

                  /// ملاحظات
                  CustomFormField(
                    controller: _notesController,
                    maxLines: 3,
                    radius: 12,
                    title: AppLocalKay.note.tr(),
                  ),

                  Gap(8.h),

                  /// رفع ملفات
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
                                  color: _uploadedFileUrl != null ? Colors.green : Colors.grey,
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
                                if (_fileName == null)
                                  Text(
                                    'PDF, PPT, Word, Video',
                                    style: AppTextStyle.titleSmall(
                                      context,
                                    ).copyWith(color: AppColor.greyColor(context)),
                                  ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// زر الإنشاء / التعديل
                  CustomButton(
                    radius: 12.r,
                    child: state.addHomeworkStatus.isLoading
                        ? CustomLoading(color: AppColor.whiteColor(context), size: 15.w)
                        : Text(
                            isEdit
                                ? AppLocalKay.edit_task.tr().tr()
                                : AppLocalKay.user_management_create_task.tr(),
                            style: AppTextStyle.titleLarge(
                              context,
                            ).copyWith(color: AppColor.whiteColor(context)),
                          ),
                    color: AppColor.accentColor(context),
                    onPressed: () {
                      setState(() => _submitted = true);
                      if (_formKey.currentState!.validate()) {
                        final request = AddHomeworkModelRequest(
                          classCodes: isEdit ? _selectedClassCode!.toString() : '',
                          sectionCode: int.parse(HiveMethods.getUserSection().toString()),
                          stageCode: int.parse(HiveMethods.getUserStage().toString()),
                          level: _selectedLevelCode!,
                          classCode: _selectedClassCode!,
                          hwDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
                          notes: _notesController.text,
                          homeworkDetails: [
                            HomeworkDetailsModel(
                              levelCode: _selectedLevelCode!,
                              classCode: _selectedClassCode!,
                              hwDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
                              hw: _descriptionController.text,
                              notes: _notesController.text,
                              courseCode: _selectedSubjectCode!,
                              hW_path: _uploadedFileUrl,
                            ),
                          ],
                        );

                        if (isEdit) {
                          context.read<HomeCubit>().editHomework(request);
                        } else {
                          context.read<HomeCubit>().addHomework(request);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
