import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/execution/assignment_detail_screen.dart';

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
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedTab == index ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _selectedTab == index
                                ? AppColor.whiteColor(context)
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(child: _buildTabContent()),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(onPressed: _createNewAssignment, child: const Icon(Icons.add))
          : null,
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
            Icon(Icons.assignment, size: 60.w, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              AppLocalKay.no_assignments.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return _buildAssignmentItem(assignments[index], showActions);
      },
    );
  }

  Widget _buildAssignmentItem(Map<String, dynamic> assignment, bool showActions) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.pending;

    switch (assignment['status']) {
      case AppLocalKay.status_pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case AppLocalKay.status_submitted:
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        break;
      case AppLocalKay.status_graded:
        statusColor = Colors.green;
        statusIcon = Icons.grade;
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          assignment['title'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('${assignment['subject']}'),
            SizedBox(height: 2.h),
            Text(
              assignment['dueDate'] ?? assignment['submittedDate'],
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
            if (assignment['grade'] != null) ...[
              SizedBox(height: 2.h),
              Text(
                'الدرجة: ${assignment['grade']}',
                style: TextStyle(fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        trailing: showActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.upload),
                    onPressed: () => _submitAssignment(assignment),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () => _viewAssignmentDetails(assignment),
                  ),
                ],
              )
            : null,
        onTap: () => _viewAssignmentDetails(assignment),
      ),
    );
  }

  void _createNewAssignment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalKay.create_new_assignment.tr(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            CustomFormField(title: AppLocalKay.assignment_title.tr(), radius: 12),
            SizedBox(height: 16.h),
            CustomFormField(title: AppLocalKay.assignment_description.tr(), radius: 12),
            SizedBox(height: 16.h),
            CustomButton(
              text: AppLocalKay.save.tr(),
              radius: 12,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAssignment(Map<String, dynamic> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.submit_assignment.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text(
          AppLocalKay.submit_confirmation.tr(),
          style: AppTextStyle.bodyMedium(context),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalKay.dialog_delete_cancel.tr()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: CustomButton(text: AppLocalKay.submit_assignment.tr(), radius: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _viewAssignmentDetails(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssignmentDetailScreen(assignment: assignment)),
    );
  }
}
