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
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  bool _submitted = false;
  String? _selectedStage;
  String? _selectedSection;
  String? _selectedLine;
  String? _selectedClass;
  String? _selectedSubject;

  DateTime? _dueDate;

  final sections = ['الابتدائية', 'المتوسطة', 'الثانوية'];
  final lines = ['الاول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
  final classes = ['A', 'B', 'C', 'D'];
  final subjects = ['الرياضيات', 'العلوم', 'اللغة العربية', 'اللغة الإنجليزية'];
  final stages = [
    'المرحلة الاولى',
    'المرحلة الثانية',
    'المرحلة الثالثة',
    'المرحلة الرابعة',
    'المرحلة الخامسة',
  ];
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().teacherLevel(int.parse(HiveMethods.getUserStage()));
    context.read<HomeCubit>().teacherCourses(int.parse(HiveMethods.getUserCode()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.create_todo.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
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
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final levels = state.teacherLevelStatus.data ?? [];
                  return CustomDropdownFormField<String>(
                    value: _selectedLine,
                    submitted: _submitted,
                    hint: AppLocalKay.user_management_class.tr(),
                    errorText: AppLocalKay.user_management_select_class.tr(),
                    items: levels
                        .map((e) => DropdownMenuItem(value: e.levelName, child: Text(e.levelName)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedLine = v;
                        _selectedClass = null; // Reset section when level changes
                      });
                      final selectedLevel = levels.firstWhere((e) => e.levelName == v);
                      context.read<HomeCubit>().teacherClasses(
                        int.parse(HiveMethods.getUserSection()),
                        int.parse(HiveMethods.getUserStage()),
                        selectedLevel.levelCode,
                      );
                    },
                  );
                },
              ),

              Gap(8.h),

              /// الشعبة
              Text(
                AppLocalKay.class_name_assigment.tr(),
                style: AppTextStyle.formTitleStyle(context),
              ),
              SizedBox(height: 8.h),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final classesList = state.teacherClassesStatus.data ?? [];
                  return CustomDropdownFormField<String>(
                    value: _selectedClass,
                    submitted: _submitted,
                    hint: AppLocalKay.class_name_assigment.tr(),
                    errorText: AppLocalKay.user_management_select_classs.tr(),
                    items: classesList
                        .map(
                          (e) => DropdownMenuItem(value: e.classNameAr, child: Text(e.classNameAr)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedClass = v),
                  );
                },
              ),

              Gap(8.h),

              /// المادة
              Text(
                AppLocalKay.user_management_subject.tr(),
                style: AppTextStyle.formTitleStyle(context),
              ),
              SizedBox(height: 8.h),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final courses = state.teacherCoursesStatus.data ?? [];
                  return CustomDropdownFormField<String>(
                    value: _selectedSubject,
                    submitted: _submitted,
                    hint: AppLocalKay.user_management_subject.tr(),
                    errorText: AppLocalKay.user_management_select_subject.tr(),
                    items: courses
                        .map(
                          (e) => DropdownMenuItem(value: e.courseName, child: Text(e.courseName)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSubject = v),
                  );
                },
              ),

              Gap(8.h),

              /// تاريخ التسليم
              CustomFormField(
                readOnly: true,
                radius: 12,
                title: AppLocalKay.user_management_deadline.tr(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDueDate,
                ),
                controller: TextEditingController(
                  text: _dueDate == null
                      ? ''
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
                validator: (_) {
                  if (_dueDate == null) {
                    return AppLocalKay.user_management_no_deadline.tr();
                  }
                  return null;
                },
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
                  await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'mp4'],
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload, size: 40.w, color: Colors.grey),
                      SizedBox(height: 8.h),
                      Text(
                        AppLocalKay.user_management_upload_files.tr(),
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              /// زر الإنشاء
              CustomButton(
                radius: 12.r,
                text: AppLocalKay.user_management_create_task.tr(),
                color: AppColor.accentColor(context),
                onPressed: () {
                  setState(() => _submitted = true);
                  if (_formKey.currentState!.validate()) {
                    _createAssignment();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _createAssignment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الواجب بنجاح'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
