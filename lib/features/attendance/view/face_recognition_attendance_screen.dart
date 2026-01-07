import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/attendance/cubit/attendance_cubit.dart';
import 'package:my_template/features/attendance/cubit/face_recognition_cubit.dart';
import 'package:my_template/features/attendance/data/models/attendance_record_model.dart';
import 'package:uuid/uuid.dart';

class FaceRecognitionAttendanceScreen extends StatefulWidget {
  final String classId;
  final String className;
  final List<Map<String, String>> students; // {id, name}

  const FaceRecognitionAttendanceScreen({
    super.key,
    required this.classId,
    required this.className,
    required this.students,
  });

  @override
  State<FaceRecognitionAttendanceScreen> createState() => _FaceRecognitionAttendanceScreenState();
}

class _FaceRecognitionAttendanceScreenState extends State<FaceRecognitionAttendanceScreen> {
  bool isScanning = false;
  bool isContinuousMode = true;
  Timer? _scanTimer;
  final Map<String, AttendanceRecordModel> attendanceRecords = {};
  final Map<String, dynamic> registeredFaces = {}; // studentId -> StudentFaceModel
  final Set<String> recognizedStudents = {}; // To track session recognitions

  // Face ID style success overlay
  String? _lastRecognizedName;
  bool _showSuccessOverlay = false;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    _initializeAttendance();
    _loadTodayAttendance();
    _loadRegisteredStudents();
  }

  void _loadRegisteredStudents() {
    context.read<FaceRecognitionCubit>().getRegisteredStudents(widget.classId);
  }

  void _loadTodayAttendance() {
    context.read<AttendanceCubit>().loadAttendance(classId: widget.classId, date: DateTime.now());
  }

  void _initializeAttendance([List<AttendanceRecordModel>? existingRecords]) {
    final Map<String, AttendanceRecordModel> existingMap = {};
    if (existingRecords != null) {
      for (var record in existingRecords) {
        existingMap[record.studentId] = record;
      }
    }

    for (var student in widget.students) {
      if (existingMap.containsKey(student['id'])) {
        attendanceRecords[student['id']!] = existingMap[student['id']]!;
      } else {
        // Only create new record if one doesn't exist for this student
        if (!attendanceRecords.containsKey(student['id'])) {
          final record = AttendanceRecordModel(
            id: const Uuid().v4(),
            studentId: student['id']!,
            studentName: student['name']!,
            classId: widget.classId,
            date: DateTime.now(),
            status: AttendanceStatus.absent,
            recognitionMethod: RecognitionMethod.manual,
          );
          attendanceRecords[student['id']!] = record;
        }
      }
    }
    setState(() {});
  }

  Future<void> _startScanning() async {
    setState(() {
      isScanning = true;
    });

    final cubit = context.read<FaceRecognitionCubit>();
    await cubit.initializeCamera(direction: CameraLensDirection.front);

    // Immediate first pass
    _performRecognition();

    if (isContinuousMode) {
      _startContinuousScanning();
    }
  }

  void _startContinuousScanning() {
    // Face ID style: very rapid scanning (every 300ms)
    _scanTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (isScanning) {
        _performRecognition();
      }
    });
  }

  Future<void> _performRecognition({String? targetStudentId}) async {
    final cubit = context.read<FaceRecognitionCubit>();
    if (cubit.state is FaceRecognitionProcessing) return;

    // If targetStudentId is provided, we only want to match that specific student
    // or at least prioritize/highlight if we found someone else.
    // For now, the cubit finds the best match among all registered.
    await cubit.recognizeStudent(
      classId: widget.classId,
      threshold: 60.0,
    ); // Face ID style: lenient threshold for fast matching
  }

  void _stopScanning() {
    setState(() {
      isScanning = false;
    });

    _scanTimer?.cancel();
    _scanTimer = null;

    final cubit = context.read<FaceRecognitionCubit>();
    cubit.disposeResources();
  }

  void _toggleStudentAttendance(String studentId, bool isPresent) {
    if (isPresent) {
      // Show validation message for manual presence
      CommonMethods.showToast(
        message: "التحضير اليدوي معطل. يرجى استخدام بصمة الوجه للتحقق.",
        seconds: 5,
        type: ToastType.error,
      );
      return;
    }

    setState(() {
      final record = attendanceRecords[studentId]!;
      attendanceRecords[studentId] = record.copyWith(
        status: AttendanceStatus.absent,
        recognitionMethod: RecognitionMethod.manual,
        checkInTime: null,
      );
      recognizedStudents.remove(studentId);
    });
  }

  void _deleteStudentRegistration(String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف بصمة الوجه"),
        content: const Text(
          "هل أنت متأكد من رغبتك في حذف بصمة الوجه لهذا الطالب؟ سيختفي الطالب من هذه القائمة بعد الحذف.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final cubit = context.read<FaceRecognitionCubit>();
              await cubit.deleteStudentFace(studentId);
              _loadRegisteredStudents(); // Refresh the list
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAttendance() async {
    final cubit = context.read<AttendanceCubit>();
    await cubit.saveAttendanceRecords(attendanceRecords.values.toList());
  }

  Map<String, int> _getStats() {
    // Only count students who have a registered face (the ones visible in the list)
    final activeRecords = attendanceRecords.values.where((r) {
      return registeredFaces.containsKey(r.studentId);
    }).toList();

    final present = activeRecords.where((r) => r.status == AttendanceStatus.present).length;
    final absent = activeRecords.where((r) => r.status == AttendanceStatus.absent).length;
    final total = activeRecords.length;

    return {
      'total': total,
      'present': present,
      'absent': absent,
      'percentage': total > 0 ? ((present / total) * 100).round() : 0,
    };
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _overlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.face_recognition_attendance.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FaceRecognitionCubit, FaceRecognitionState>(
            listener: (context, state) {
              if (state is FaceRecognitionStudentRecognized) {
                final studentId = state.student.studentId;

                if (!recognizedStudents.contains(studentId)) {
                  setState(() {
                    recognizedStudents.add(studentId);
                    final record = attendanceRecords[studentId]!;
                    attendanceRecords[studentId] = record.copyWith(
                      status: AttendanceStatus.present,
                      recognitionMethod: RecognitionMethod.faceRecognition,
                      confidenceScore: state.confidence,
                      checkInTime: DateTime.now(),
                    );

                    // Face ID style: show success overlay
                    _lastRecognizedName = state.student.studentName;
                    _showSuccessOverlay = true;
                  });

                  // Hide overlay after 1.5 seconds
                  _overlayTimer?.cancel();
                  _overlayTimer = Timer(const Duration(milliseconds: 1500), () {
                    if (mounted) {
                      setState(() => _showSuccessOverlay = false);
                    }
                  });

                  // Face ID style: Only stop in single scan mode, keep scanning in continuous
                  if (!isContinuousMode) {
                    _stopScanning();
                  }
                }
              } else if (state is FaceRecognitionNoMatch) {
                // In continuous mode, we DON'T show error or stop scanning.
                // We just let the timer trigger the next attempt silently.
                if (!isContinuousMode) {
                  CommonMethods.showToast(
                    message:
                        "لم يتم التعرف على الوجه. يرجى التأكد من التسجيل أو المحاولة مرة أخرى.",
                    seconds: 5,
                    type: ToastType.error,
                  );

                  // Auto stop camera if single scan fails
                  _stopScanning();
                }
              } else if (state is FaceRecognitionError) {
                if (state.message.contains('No registered faces')) {
                  CommonMethods.showToast(
                    message: state.message,
                    seconds: 5,
                    type: ToastType.error,
                  );
                  _stopScanning();
                }
              } else if (state is FaceRecognitionNoMatch) {
              } else if (state is FaceRecognitionRegisteredStudentsLoaded) {
                setState(() {
                  registeredFaces.clear();
                  for (var face in state.students) {
                    registeredFaces[face.studentId] = face;
                  }
                });
              }
            },
          ),
          BlocListener<AttendanceCubit, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceLoaded) {
                _initializeAttendance(state.records);
              } else if (state is AttendanceSaved) {
                CommonMethods.showToast(
                  message: AppLocalKay.user_management_save.tr(),
                  type: ToastType.success,
                );
                Navigator.pop(context);
              } else if (state is AttendanceError) {
                print('Attendance Error: ${state.message}');
                CommonMethods.showToast(message: state.message, type: ToastType.error);
              }
            },
          ),
        ],
        child: Column(
          children: [
            _buildHeader(),

            if (isScanning) Expanded(flex: 3, child: _buildCameraView()) else _buildStatistics(),

            // Student List (smaller when camera is active)
            Expanded(flex: 1, child: _buildStudentList()),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.primaryColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: isContinuousMode,
            onChanged: isScanning
                ? null
                : (value) {
                    setState(() {
                      isContinuousMode = value;
                    });
                  },
            activeColor: AppColor.primaryColor(context),
          ),
          SizedBox(width: 8.w),
          Text(
            isContinuousMode ? AppLocalKay.continuous_scan.tr() : AppLocalKay.single_scan.tr(),
            style: AppTextStyle.bodySmall(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return BlocBuilder<FaceRecognitionCubit, FaceRecognitionState>(
      builder: (context, state) {
        final cubit = context.read<FaceRecognitionCubit>();
        final controller = cubit.cameraService.controller;

        if (controller == null || !controller.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(controller),
            ),
            Positioned(
              top: 16.h,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  AppLocalKay.scanning_faces.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (state is FaceRecognitionProcessing)
              const Center(child: CircularProgressIndicator(color: Colors.white)),

            // Face ID Style Success Overlay
            if (_showSuccessOverlay)
              Container(
                color: Colors.green.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 60.sp),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _lastRecognizedName ?? '',
                        style: AppTextStyle.headlineMedium(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [const Shadow(color: Colors.black, blurRadius: 8)],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "تم التحضير ✓",
                        style: AppTextStyle.titleMedium(context).copyWith(
                          color: Colors.white,
                          shadows: [const Shadow(color: Colors.black, blurRadius: 8)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatistics() {
    final stats = _getStats();

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            AppLocalKay.user_management_attendees.tr(),
            '${stats['present']}',
            AppColor.secondAppColor(context),
          ),
          _buildStat(
            AppLocalKay.user_management_absent.tr(),
            '${stats['absent']}',
            AppColor.errorColor(context),
          ),
          _buildStat(
            AppLocalKay.user_management_percentage.tr(),
            '${stats['percentage']}%',
            AppColor.primaryColor(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.headlineLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(title, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildStudentList() {
    // Filter students: Show only those who have a registered face
    final filteredStudents = widget.students.where((student) {
      return registeredFaces.containsKey(student['id']);
    }).toList();

    if (filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.face_retouching_off, size: 64, color: Colors.grey),
            SizedBox(height: 16.h),
            Text("لا يوجد طلاب مسجلين للتعرف على الوجه", style: AppTextStyle.bodyMedium(context)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        final studentId = student['id']!;
        final studentName = student['name']!;

        // Ensure record exists (fallback if init had issues)
        if (!attendanceRecords.containsKey(studentId)) {
          return const SizedBox();
        }

        final record = attendanceRecords[studentId]!;

        return _buildStudentCard(studentId: studentId, studentName: studentName, record: record);
      },
    );
  }

  Widget _buildStudentCard({
    required String studentId,
    required String studentName,
    required AttendanceRecordModel record,
  }) {
    final isPresent = record.status == AttendanceStatus.present;
    final isAutoDetected = record.recognitionMethod == RecognitionMethod.faceRecognition;
    final faceModel = registeredFaces[studentId];
    final hasRegisteredFace = faceModel != null;

    return InkWell(
      onLongPress: () => _deleteStudentRegistration(studentId),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: hasRegisteredFace
                      ? DecorationImage(
                          image: FileImage(File(faceModel.faceImagePath)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasRegisteredFace ? Icon(Icons.person, color: Colors.grey) : null,
              ),
              // Status Indicator Overlay
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPresent ? Colors.green : Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: isPresent
                      ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                      : SizedBox(width: 12.sp, height: 12.sp),
                ),
              ),
            ],
          ),
          title: Row(
            children: [
              Expanded(child: Text(studentName, overflow: TextOverflow.ellipsis)),
              if (hasRegisteredFace) ...[
                SizedBox(width: 4.w),
                Icon(Icons.verified_user, size: 16.sp, color: Colors.blue),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'ID: ',
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '$studentId\n',
                      style: TextStyle(fontSize: 10.sp),
                    ),

                    if (isPresent && record.checkInTime != null) ...[
                      const TextSpan(
                        text: 'Time: ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${DateFormat('hh:mm:ss a yyyy-MM-dd', 'en').format(record.checkInTime!)}\n',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],

                    if (isPresent && isAutoDetected && record.confidenceScore != null) ...[
                      const TextSpan(
                        text: 'Match: ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${record.confidenceScore!.toStringAsFixed(1)}%\n',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: '(تم التحقق بنجاح)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasRegisteredFace && !isPresent)
                IconButton(
                  icon: Icon(Icons.center_focus_strong, color: AppColor.primaryColor(context)),
                  onPressed: () {
                    if (!isScanning) {
                      _startScanning();
                    }
                    _performRecognition(targetStudentId: studentId);
                  },
                  tooltip: "تحقق من الوجه",
                ),
              // Switch allows toggling, but manual check-in is still guarded in _toggleStudentAttendance
              Switch(
                value: isPresent,
                onChanged: (value) => _toggleStudentAttendance(studentId, value),
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          if (!isScanning) ...[
            Expanded(
              child: CustomButton(
                text: AppLocalKay.start_scanning.tr(),
                radius: 12.r,
                onPressed: _startScanning,
                color: AppColor.primaryColor(context),
              ),
            ),
            SizedBox(width: 12.w),
          ] else ...[
            Expanded(
              child: CustomButton(
                text: AppLocalKay.stop_scanning.tr(),
                radius: 12.r,
                onPressed: _stopScanning,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {
                return CustomButton(
                  text: AppLocalKay.user_management_save.tr(),
                  radius: 12.r,
                  onPressed: state is AttendanceSaving ? null : _saveAttendance,
                  color: AppColor.secondAppColor(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
