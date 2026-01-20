import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/assignment_model.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  AssignmentStatus? _selectedFilter;

  final List<AssignmentModel> _dummyAssignments = [
    AssignmentModel(
      id: "1",
      title: "بحث في تاريخ العلوم",
      subject: "التاريخ",
      description: "اكتب بحثاً من 3 صفحات عن علماء العصر الذهبي.",
      dueDate: DateTime.now().add(const Duration(days: 2)),
      status: AssignmentStatus.pending,
    ),
    AssignmentModel(
      id: "2",
      title: "حل تمارين الجبر",
      subject: "الرياضيات",
      description: "حل المسائل من صفحة 45 إلى 50.",
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      status: AssignmentStatus.submitted,
    ),
    AssignmentModel(
      id: "3",
      title: "تحليل نص شعري",
      subject: "اللغة العربية",
      description: "حلل الأبيات العشرة الأولى من معلقة امرئ القيس.",
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      status: AssignmentStatus.graded,
      grade: 95,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilter == null
        ? _dummyAssignments
        : _dummyAssignments.where((a) => a.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(context, title: const Text("الواجبات والمهام")),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return _buildAssignmentCard(filteredList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(null, "الكل"),
          _buildFilterChip(AssignmentStatus.pending, "قيد التنفيذ"),
          _buildFilterChip(AssignmentStatus.submitted, "تم التسليم"),
          _buildFilterChip(AssignmentStatus.graded, "مصصح"),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AssignmentStatus? status, String label) {
    bool isSelected = _selectedFilter == status;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() => _selectedFilter = status);
        },
        selectedColor: AppColor.primaryColor(context).withOpacity(0.2),
        checkmarkColor: AppColor.primaryColor(context),
        labelStyle: AppTextStyle.bodySmall(context).copyWith(
          color: isSelected ? AppColor.primaryColor(context) : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(AssignmentModel assignment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(assignment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _getStatusLabel(assignment.status),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: _getStatusColor(assignment.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                assignment.subject,
                style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            assignment.title,
            style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            assignment.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.black54),
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    "موعد التسليم: ${DateFormat('yyyy-MM-dd').format(assignment.dueDate)}",
                    style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                  ),
                ],
              ),
              if (assignment.status == AssignmentStatus.graded)
                Text(
                  "الدرجة: ${assignment.grade}/100",
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return Colors.orange;
      case AssignmentStatus.submitted:
        return Colors.blue;
      case AssignmentStatus.graded:
        return Colors.green;
      case AssignmentStatus.late:
        return Colors.red;
    }
  }

  String _getStatusLabel(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return "قيد التنفيذ";
      case AssignmentStatus.submitted:
        return "تم التسليم";
      case AssignmentStatus.graded:
        return "تم التصحيح";
      case AssignmentStatus.late:
        return "متأخر";
    }
  }
}
