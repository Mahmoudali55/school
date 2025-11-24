import 'package:flutter/material.dart';
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

  final studentData = {
    'name': 'محمد أحمد السعيد',
    'email': 'mohammed.ahmed@school.com',
    'grade': 'الصف العاشر',
    'section': 'القسم العلمي',
    'attendanceRate': 95,
    'averageGrade': 88.5,
  };

  final activities = [
    {
      'title': 'تم تسليم واجب الرياضيات',
      'time': 'قبل ساعتين',
      'icon': Icons.assignment_turned_in,
      'color': Colors.green,
    },
    {'title': 'اختبار الفيزياء', 'time': 'قبل 5 ساعات', 'icon': Icons.quiz, 'color': Colors.blue},
    {
      'title': 'حضور حصة الكيمياء',
      'time': 'أمس',
      'icon': Icons.video_library,
      'color': Colors.orange,
    },
  ];

  final achievements = [
    {
      'title': 'التميز الأكاديمي',
      'desc': 'أعلى درجة في الرياضيات',
      'icon': Icons.emoji_events,
      'color': Colors.amber,
    },
    {
      'title': 'الحضور المثالي',
      'desc': '100% حضور الشهر',
      'icon': Icons.verified_user,
      'color': Colors.green,
    },
  ];

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
      body: Column(
        children: [
          ProfileHeader(studentData: studentData),
          ProfileTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                InfoTab(studentData: studentData),
                ActivitiesTab(activities: activities),
                AchievementsTab(achievements: achievements),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
