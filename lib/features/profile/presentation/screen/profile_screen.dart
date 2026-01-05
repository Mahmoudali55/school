import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';
import 'package:my_template/features/profile/presentation/screen/widget/achievements_tab_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/activities_tab_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/profile_Info_tab.dart';
import 'package:my_template/features/profile/presentation/screen/widget/profile_header_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/profile_tabBar_widget.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.profile == null) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          final studentData = {
            'name': state.profile!.name,
            'email': state.profile!.email,
            'grade': state.profile!.grade ?? '',
            'section': state.profile!.section ?? '',
            'attendanceRate': state.profile!.attendanceRate ?? 0,
            'averageGrade': state.profile!.averageGrade ?? 0,
          };

          return Column(
            children: [
              ProfileHeader(studentData: studentData),
              ProfileTabBar(tabController: _tabController),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    InfoTab(studentData: studentData),
                    ActivitiesTab(
                      activities: state.activities
                          .map(
                            (a) => {
                              'title': a.title,
                              'time': a.time,
                              'icon': a.icon,
                              'color': a.color,
                            },
                          )
                          .toList(),
                    ),
                    AchievementsTab(
                      achievements: state.achievements
                          .map(
                            (a) => {
                              'title': a.title,
                              'desc': a.desc,
                              'icon': a.icon,
                              'color': a.color,
                            },
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
