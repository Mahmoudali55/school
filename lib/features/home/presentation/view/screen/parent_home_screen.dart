import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/header_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/live_tracking_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/requests_section_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/student_snapshot_section_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/urgent_alerts_widget%20.dart';

class HomeParentScreen extends StatefulWidget {
  const HomeParentScreen({super.key});

  @override
  State<HomeParentScreen> createState() => _HomeParentScreenState();
}

class _HomeParentScreenState extends State<HomeParentScreen> {
  @override
  void initState() {
    super.initState();

    // تأخير بسيط عشان context يكون جاهز
    Future.microtask(() {
      context.read<HomeCubit>().parentData(int.parse(HiveMethods.getUserCode()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // we no longer return a full-screen Loader or Error here
            // to allow static parts of the screen to show up immediately.

            final bool isLoadingStudents =
                state.parentsStudentStatus.isLoading || state.parentsStudentStatus.isInitial;

            final List<StudentMiniInfo>? students = state.parentsStudentStatus.data?.map((e) {
              return e.toMiniInfo();
            }).toList();

            final StudentMiniInfo? selectedStudent =
                state.selectedStudent ??
                (students != null && students.isNotEmpty ? students[0] : null);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    parentName: HiveMethods.getUserName(),
                    students: students, // might be null
                    selectedStudent: selectedStudent, // might be null
                  ),
                  SizedBox(height: 25.h),
                  StudentSnapshotWidget(studentCode: selectedStudent?.studentCode),
                  SizedBox(height: 25.h),
                  const LiveTrackingWidget(),
                  SizedBox(height: 25.h),
                  RequestsSectionWidget(selectedStudent: selectedStudent, students: students ?? []),
                  SizedBox(height: 25.h),
                  const UrgentAlertsWidget(),
                  if (state.parentsStudentStatus.isFailure)
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Center(
                        child: Text(
                          state.parentsStudentStatus.error ?? "حدث خطأ في تحميل بيانات الطلاب",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  SizedBox(height: 30.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
