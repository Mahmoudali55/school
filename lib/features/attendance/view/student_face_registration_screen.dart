import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/attendance/cubit/face_recognition_cubit.dart';

class StudentFaceRegistrationScreen extends StatefulWidget {
  final String classId;
  final String className;
  final List<Map<String, String>> students; // {id, name}

  const StudentFaceRegistrationScreen({
    super.key,
    required this.classId,
    required this.className,
    required this.students,
  });

  @override
  State<StudentFaceRegistrationScreen> createState() => _StudentFaceRegistrationScreenState();
}

class _StudentFaceRegistrationScreenState extends State<StudentFaceRegistrationScreen> {
  String? selectedStudentId;
  String? selectedStudentName;
  bool isCapturing = false;
  Set<String> registeredStudents = {};

  @override
  void initState() {
    super.initState();
    _loadRegisteredStudents();
  }

  Future<void> _loadRegisteredStudents() async {
    final cubit = context.read<FaceRecognitionCubit>();
    await cubit.getRegisteredStudents(widget.classId);
  }

  void _selectStudent(String id, String name) {
    setState(() {
      selectedStudentId = id;
      selectedStudentName = name;
    });
  }

  Future<void> _openCamera() async {
    if (selectedStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalKay.select_student_to_register.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isCapturing = true;
    });

    final cubit = context.read<FaceRecognitionCubit>();
    await cubit.initializeCamera();
  }

  Future<void> _captureAndRegister() async {
    if (selectedStudentId == null || selectedStudentName == null) return;

    final cubit = context.read<FaceRecognitionCubit>();
    await cubit.registerStudentFace(
      studentId: selectedStudentId!,
      studentName: selectedStudentName!,
      classId: widget.classId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.face_registration.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<FaceRecognitionCubit, FaceRecognitionState>(
        listener: (context, state) {
          if (state is FaceRecognitionRegistered) {
            setState(() {
              registeredStudents.add(state.faceModel.studentId);
              isCapturing = false;
              selectedStudentId = null;
              selectedStudentName = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalKay.face_registered_successfully.tr()),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is FaceRecognitionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          } else if (state is FaceRecognitionRegisteredStudentsLoaded) {
            setState(() {
              registeredStudents = state.students.map((student) => student.studentId).toSet();
            });
          }
        },
        builder: (context, state) {
          if (isCapturing && state is FaceRecognitionCameraReady) {
            return _buildCameraView(state);
          }

          return _buildStudentList(state);
        },
      ),
    );
  }

  Widget _buildStudentList(FaceRecognitionState state) {
    final notRegistered = widget.students
        .where((s) => !registeredStudents.contains(s['id']))
        .toList();
    final registered = widget.students.where((s) => registeredStudents.contains(s['id'])).toList();

    return Column(
      children: [
        // Statistics
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.primaryColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                AppLocalKay.students_registered.tr(),
                '${registered.length}',
                AppColor.secondAppColor(context),
              ),
              _buildStat(
                AppLocalKay.students_not_registered.tr(),
                '${notRegistered.length}',
                AppColor.accentColor(context),
              ),
            ],
          ),
        ),

        // Not Registered Students
        if (notRegistered.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppLocalKay.students_not_registered.tr(),
                style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: notRegistered.length,
              itemBuilder: (context, index) {
                final student = notRegistered[index];
                return _buildStudentCard(student['id']!, student['name']!, false);
              },
            ),
          ),
        ],

        // Registered Students
        if (registered.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppLocalKay.students_registered.tr(),
                style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: registered.length,
              itemBuilder: (context, index) {
                final student = registered[index];
                return _buildStudentCard(student['id']!, student['name']!, true);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStudentCard(String id, String name, bool isRegistered) {
    final isSelected = selectedStudentId == id;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: isSelected ? AppColor.primaryColor(context).withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isRegistered
              ? AppColor.secondAppColor(context).withValues(alpha: 0.1)
              : AppColor.accentColor(context).withValues(alpha: 0.1),
          child: Icon(
            isRegistered ? Icons.check_circle : Icons.face,
            color: isRegistered ? AppColor.secondAppColor(context) : AppColor.accentColor(context),
          ),
        ),
        title: Text(name),
        subtitle: Text(
          isRegistered
              ? AppLocalKay.face_registered_successfully.tr()
              : AppLocalKay.register_face.tr(),
        ),
        trailing: isRegistered
            ? IconButton(
                icon: Icon(Icons.delete, color: AppColor.errorColor(context)),
                onPressed: () => _deleteRegistration(id),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  _selectStudent(id, name);
                  _openCamera();
                },
                icon: const Icon(Icons.camera_alt, size: 18),
                label: Text(AppLocalKay.register_face.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor(context),
                  foregroundColor: AppColor.whiteColor(context),
                ),
              ),
      ),
    );
  }

  Widget _buildCameraView(FaceRecognitionState state) {
    final cubit = context.read<FaceRecognitionCubit>();
    final controller = cubit.cameraService.controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Camera Preview
        SizedBox(width: double.infinity, height: double.infinity, child: CameraPreview(controller)),

        // Overlay with instructions
        Positioned(
          top: 40.h,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.blackColor(context).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  selectedStudentName ?? '',
                  style: AppTextStyle.titleLarge(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalKay.position_face_in_frame.tr(),
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.whiteColor(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // Face detection guide
        Center(
          child: Container(
            width: 250.w,
            height: 300.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.secondAppColor(context), width: 3),
              borderRadius: BorderRadius.circular(150.r),
            ),
          ),
        ),

        // Capture Button
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel Button
              FloatingActionButton(
                heroTag: 'cancel',
                onPressed: () {
                  setState(() {
                    isCapturing = false;
                  });
                  cubit.disposeResources();
                },
                backgroundColor: AppColor.errorColor(context),
                child: const Icon(Icons.close),
              ),

              // Capture Button
              FloatingActionButton.extended(
                heroTag: 'capture',
                onPressed: state is FaceRecognitionProcessing ? null : _captureAndRegister,
                backgroundColor: AppColor.primaryColor(context),
                icon: state is FaceRecognitionProcessing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColor.whiteColor(context),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.camera),
                label: Text(AppLocalKay.capture_face.tr()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.headlineMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          title,
          style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.hintColor(context)),
        ),
      ],
    );
  }

  Future<void> _deleteRegistration(String studentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.delete_face_registration.tr()),
        content: Text(AppLocalKay.delete_user_message.tr()),
        actions: [
          CustomButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalKay.cancel.tr()),
          ),
          CustomButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalKay.delete.tr(),
              style: TextStyle(color: AppColor.errorColor(context)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final cubit = context.read<FaceRecognitionCubit>();
      await cubit.deleteStudentFace(studentId);

      setState(() {
        registeredStudents.remove(studentId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalKay.face_registration_deleted.tr()),
            backgroundColor: AppColor.secondAppColor(context),
          ),
        );
      }
    }
  }
}
