import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/profile/data/model/student_profile_model.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';
import 'package:my_template/features/profile/presentation/screen/widget/fade_slide_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/profile_header_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/profile_info_row.dart';
import 'package:my_template/features/profile/presentation/screen/widget/tab_bar_delegate_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<ProfileCubit>().StudentProfile(int.tryParse(HiveMethods.getUserCode()) ?? 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.studentProfileStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.studentProfileStatus.isFailure && state.error != null) {
            return Center(child: Text(state.error!));
          }

          final student = state.studentProfileStatus.data;
          if (student == null) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          return DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(child: ProfileHeader(studentData: student)),
                SliverPersistentHeader(pinned: true, delegate: TabBarDelegate(_tabController)),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  FadeSlide(child: _buildPersonalInfo(student)),
                  FadeSlide(child: _buildAcademicInfo(student)),
                  FadeSlide(child: _buildParentInfo(student)),
                  FadeSlide(child: _buildOtherInfo(student)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfo(StudentProfileModel student) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildSectionCard([
            ProfileInfoRow(
              label: "أسم الطالب كامل",
              value: student.studentFullName,
              icon: Icons.person,
            ),
            ProfileInfoRow(label: "تاريخ الميلاد", value: student.birthDate, icon: Icons.cake),
            ProfileInfoRow(
              label: "العمر",
              value: "${student.ageYear} سنة و ${student.ageMonth} شهر",
              icon: Icons.timelapse,
            ),
            ProfileInfoRow(label: "رقم الهوية", value: student.idNo, icon: Icons.badge),
            ProfileInfoRow(
              label: "الجنس",
              value: student.gender == 0 ? "ذكر" : "أنثى",
              icon: Icons.wc,
            ),
            ProfileInfoRow(label: "تاريخ التسجيل", value: student.regDate, icon: Icons.date_range),
          ]),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo(StudentProfileModel student) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildSectionCard([
            ProfileInfoRow(label: "المرحلة", value: student.stageName, icon: Icons.school),
            ProfileInfoRow(label: "الصف", value: student.levelName, icon: Icons.stairs),
            ProfileInfoRow(label: "الفصل", value: student.className, icon: Icons.class_),
            ProfileInfoRow(label: "القسم", value: student.sectionName, icon: Icons.category),
            ProfileInfoRow(
              label: "كود الطالب",
              value: student.studentCode.toString(),
              icon: Icons.qr_code,
            ),
            ProfileInfoRow(
              label: "نظام الأولوية",
              value: student.prioritySystemName,
              icon: Icons.priority_high,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildParentInfo(StudentProfileModel student) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildSectionCard([
            ProfileInfoRow(
              label: "أسم ولي الأمر",
              value: student.parentName,
              icon: Icons.family_restroom,
            ),
            ProfileInfoRow(
              label: "كود ولي الأمر",
              value: student.parentCode.toString(),
              icon: Icons.numbers,
            ),
            ProfileInfoRow(
              label: "عدد الأبناء",
              value: student.employeeChildren.toString(),
              icon: Icons.child_care,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOtherInfo(StudentProfileModel student) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildSectionCard([
            ProfileInfoRow(
              label: "حالة الطالب",
              value: student.sStateName,
              icon: Icons.info_outline,
            ),
            ProfileInfoRow(
              label: "رقم الحافلة",
              value: student.busCode.toString(),
              icon: Icons.directions_bus,
            ),
            ProfileInfoRow(
              label: "نوع النقل",
              value: student.transportType.toString(),
              icon: Icons.commute,
            ),
            ProfileInfoRow(label: "قادم من", value: student.comeFrom ?? "-", icon: Icons.place),
            ProfileInfoRow(
              label: "ملف مرفق",
              value: student.sState == 1 ? "نعم" : "لا",
              icon: Icons.attach_file,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(children: children),
      ),
    );
  }
}
