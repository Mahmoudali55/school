import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/student_class_data_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class RecordingAbsenceScreen extends StatefulWidget {
  const RecordingAbsenceScreen({super.key});

  @override
  State<RecordingAbsenceScreen> createState() => _RecordingAbsenceScreenState();
}

class _RecordingAbsenceScreenState extends State<RecordingAbsenceScreen> {
  TeacherLevelModel? _selectedLevel;
  TeacherClassModels? _selectedClass;
  final Map<int, bool> _attendance = {};

  @override
  void initState() {
    super.initState();
    // Load teacher levels on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
        context.read<HomeCubit>().teacherLevel(stageCode);
      }
    });
  }

  void _onLevelChanged(TeacherLevelModel? level) {
    setState(() {
      _selectedLevel = level;
      _selectedClass = null; // Reset class selection when level changes
      _attendance.clear(); // Clear attendance when level changes
    });

    if (level != null) {
      // Load classes for selected level
      final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
      final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
      context.read<HomeCubit>().teacherClasses(sectionCode, stageCode, level.levelCode);
    }
  }

  void _onClassChanged(TeacherClassModels? newValue) {
    setState(() {
      _selectedClass = newValue;
      _attendance.clear(); // Clear local attendance tracking for new class
    });
    if (newValue != null) {
      context.read<HomeCubit>().studentData(code: newValue.classCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.check_in.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final levels = state.teacherLevelStatus.data ?? [];
          final classes = state.teacherClassesStatus.data ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.user_management_class.tr(),
                  style: AppTextStyle.titleMedium(context),
                ),
                Gap(8.h),
                CustomDropdownFormField(
                  value: _selectedLevel,
                  errorText: '',
                  submitted: false,
                  hint: AppLocalKay.select.tr(),
                  items: levels.map((TeacherLevelModel level) {
                    return DropdownMenuItem<TeacherLevelModel>(
                      value: level,
                      child: Text(level.levelName),
                    );
                  }).toList(),
                  onChanged: state.teacherLevelStatus.isLoading ? null : _onLevelChanged,
                ),
                Gap(5.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalKay.class_name_assigment.tr(),
                            style: AppTextStyle.titleMedium(context),
                          ),
                          Gap(8.h),
                          CustomDropdownFormField(
                            value: _selectedClass,
                            errorText: '',
                            submitted: false,
                            hint: AppLocalKay.select.tr(),
                            items: classes.map((TeacherClassModels classItem) {
                              return DropdownMenuItem<TeacherClassModels>(
                                value: classItem,
                                child: Text(classItem.classNameAr),
                              );
                            }).toList(),
                            onChanged:
                                _selectedLevel == null || state.teacherClassesStatus.isLoading
                                ? null
                                : _onClassChanged,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalKay.user_management_date.tr(),
                            style: AppTextStyle.titleMedium(context),
                          ),
                          Gap(8.h),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                              suffixIcon: Icon(Icons.calendar_today),
                              filled: true,
                              fillColor: AppColor.textFormFillColor(context),
                            ),
                            controller: TextEditingController(
                              text:
                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(10),
                Expanded(child: _buildStudentListSection(state)),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    text: AppLocalKay.user_management_save.tr(),
                    radius: 12.r,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentListSection(HomeState state) {
    if (state.studentDataStatus.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state.studentDataStatus.isFailure) {
      return Center(child: Text(state.studentDataStatus.error ?? 'Error loading students'));
    }

    final studentData = state.studentDataStatus.data;
    if (studentData == null || studentData.students.isEmpty) {
      return Center(
        child: Text(
          _selectedClass == null ? 'يرجى اختيار الفصل' : 'لا يوجد طلاب في هذا الفصل',
          style: AppTextStyle.bodyMedium(context),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: studentData.students.length,
      itemBuilder: (context, index) {
        return _buildStudentCard(studentData.students[index]);
      },
    );
  }

  Widget _buildStudentCard(StudentItem student) {
    final isPresent = _attendance[student.studentCode] ?? true;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
          child: Icon(
            isPresent ? Icons.check : Icons.close,
            color: isPresent ? Colors.green : Colors.red,
          ),
        ),
        title: Text(student.studentName),
        subtitle: Text('الرقم: ${student.studentCode}'),
        trailing: Switch(
          value: isPresent,
          onChanged: (value) {
            setState(() {
              _attendance[student.studentCode] = value;
            });
          },
          activeColor: const Color(0xFF10B981),
        ),
      ),
    );
  }
}
