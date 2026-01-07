// lib/features/classes/presentation/screens/class_details_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/attendance/cubit/attendance_cubit.dart';
import 'package:my_template/features/attendance/cubit/face_recognition_cubit.dart';
import 'package:my_template/features/attendance/view/face_recognition_attendance_screen.dart';
import 'package:my_template/features/attendance/view/student_face_registration_screen.dart';
import 'package:my_template/features/class/presentation/execution/add_edit_class_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_reports_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_schedule_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_students_screen.dart';

import '../../data/model/school_class_model.dart';

class ClassDetailsScreen extends StatelessWidget {
  final SchoolClass schoolClass;

  const ClassDetailsScreen({super.key, required this.schoolClass});

  @override
  Widget build(BuildContext context) {
    double fillPercentage = (schoolClass.currentStudents / schoolClass.capacity) * 100;

    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.class_details.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة المعلومات الأساسية
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schoolClass.name,
                      style: AppTextStyle.headlineLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                    ),
                    SizedBox(height: 16.h),

                    _buildDetailItem(
                      AppLocalKay.user_management_class.tr(),
                      schoolClass.grade,
                      Icons.grade,
                      context,
                    ),
                    _buildDetailItem(
                      AppLocalKay.section.tr(),
                      schoolClass.section,
                      Icons.category,
                      context,
                    ),
                    _buildDetailItem(
                      AppLocalKay.teacher.tr(),
                      schoolClass.teacher,
                      Icons.person,
                      context,
                    ),
                    _buildDetailItem(
                      AppLocalKay.label_room.tr(),
                      schoolClass.room,
                      Icons.room,
                      context,
                    ),
                    _buildDetailItem(
                      AppLocalKay.schedule.tr(),
                      schoolClass.schedule,
                      Icons.schedule,
                      context,
                    ),

                    SizedBox(height: 16.h),

                    // إحصائيات السعة
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalKay.label_capacity.tr(),
                                style: AppTextStyle.titleMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${schoolClass.currentStudents}/${schoolClass.capacity}',
                                style: AppTextStyle.titleMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: fillPercentage >= 90
                                      ? Colors.red
                                      : fillPercentage >= 70
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          LinearProgressIndicator(
                            value: schoolClass.currentStudents / schoolClass.capacity,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              fillPercentage >= 90
                                  ? Colors.red
                                  : fillPercentage >= 70
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            minHeight: 12.h,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${fillPercentage.toStringAsFixed(1)}% ${AppLocalKay.stats_fill_rate.tr()}',
                            style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              AppLocalKay.quick_actions.tr(),
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
            ),
            SizedBox(height: 16.h),

            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.2,
              ),
              children: [
                _buildActionCard(
                  AppLocalKay.student_management.tr(),
                  Icons.people,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassStudentsScreen(schoolClass: schoolClass),
                      ),
                    );
                  },
                  context,
                ),
                _buildActionCard(AppLocalKay.edit_class.tr(), Icons.edit, Colors.orange, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditClassScreen(schoolClass: schoolClass),
                    ),
                  );
                }, context),
                _buildActionCard(
                  AppLocalKay.schedules.tr(),
                  Icons.calendar_today,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassScheduleScreen(schoolClass: schoolClass),
                      ),
                    );
                  },
                  context,
                ),
                _buildActionCard(AppLocalKay.reports.tr(), Icons.analytics, Colors.purple, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassReportsScreen(schoolClass: schoolClass),
                    ),
                  );
                }, context),
                _buildActionCard(
                  AppLocalKay.register_student_faces.tr(),
                  Icons.face_retouching_natural,
                  Colors.teal,
                  () {
                    // TODO: Replace with actual students list from cubit
                    final students = [
                      {'id': '1', 'name': 'أحمد محمد'},
                      {'id': '2', 'name': 'فاطمة علي'},
                    ];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => sl<FaceRecognitionCubit>(),
                          child: StudentFaceRegistrationScreen(
                            classId: schoolClass.id,
                            className: schoolClass.name,
                            students: students,
                          ),
                        ),
                      ),
                    );
                  },
                  context,
                ),
                _buildActionCard(
                  AppLocalKay.face_recognition_attendance.tr(),
                  Icons.camera_front,
                  Colors.indigo,
                  () {
                    // TODO: Replace with actual students list from cubit
                    final students = [
                      {'id': '1', 'name': 'أحمد محمد'},
                      {'id': '2', 'name': 'فاطمة علي'},
                    ];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(create: (context) => sl<FaceRecognitionCubit>()),
                            BlocProvider(create: (context) => sl<AttendanceCubit>()),
                          ],
                          child: FaceRecognitionAttendanceScreen(
                            classId: schoolClass.id,
                            className: schoolClass.name,
                            students: students,
                          ),
                        ),
                      ),
                    );
                  },
                  context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey)),
              Text(
                value,
                style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    BuildContext context,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30.w, color: color),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
