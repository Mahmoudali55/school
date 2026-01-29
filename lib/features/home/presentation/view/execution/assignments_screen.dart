import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/execution/assignment_detail_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/widget/assignment_card.dart';
import 'package:my_template/features/home/presentation/view/execution/widget/assignment_tabs.dart';
import 'package:my_template/features/home/presentation/view/execution/widget/submit_assignment_dialog.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['المعلقة', 'المسلمة', 'المصححة'];

  final List<Map<String, dynamic>> _pendingAssignments = [
    {
      'title': 'واجب الرياضيات - الجبر',
      'subject': 'الرياضيات',
      'dueDate': '2024-01-15',
      'status': 'معلق',
      'priority': 'high',
    },
    {
      'title': 'بحث الفيزياء',
      'subject': 'الفيزياء',
      'dueDate': '2024-01-20',
      'status': 'معلق',
      'priority': 'medium',
    },
  ];

  final List<Map<String, dynamic>> _submittedAssignments = [
    {
      'title': 'تمارين الكيمياء',
      'subject': 'الكيمياء',
      'submittedDate': '2024-01-10',
      'status': 'مسلم',
    },
  ];

  final List<Map<String, dynamic>> _gradedAssignments = [
    {
      'title': 'اختبار اللغة العربية',
      'subject': 'اللغة العربية',
      'grade': '85/100',
      'submittedDate': '2024-01-05',
      'status': 'مصحح',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.tasks.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          AssignmentTabs(
            selectedTab: _selectedTab,
            tabs: _tabs,
            onTabChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),

          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildAssignmentsList(_pendingAssignments, true);
      case 1:
        return _buildAssignmentsList(_submittedAssignments, false);
      case 2:
        return _buildAssignmentsList(_gradedAssignments, false);
      default:
        return _buildAssignmentsList(_pendingAssignments, true);
    }
  }

  Widget _buildAssignmentsList(List<Map<String, dynamic>> assignments, bool showActions) {
    if (assignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 60.w, color: AppColor.greyColor(context)),
            SizedBox(height: 16.h),
            Text(
              AppLocalKay.no_assignments.tr(),
              style: AppTextStyle.titleMedium(context).copyWith(color: AppColor.greyColor(context)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return AssignmentCard(
          assignment: assignments[index],
          showActions: showActions,
          onSubmit: _submitAssignment,
          onViewDetails: _viewAssignmentDetails,
        );
      },
    );
  }

  void _submitAssignment(Map<String, dynamic> assignment) {
    showDialog(context: context, builder: (context) => const SubmitAssignmentDialog());
  }

  void _viewAssignmentDetails(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssignmentDetailScreen(assignment: assignment)),
    );
  }
}
