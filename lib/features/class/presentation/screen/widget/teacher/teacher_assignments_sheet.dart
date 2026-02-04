import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/view/execution/create_assignment_screen.dart';

import 'teacher_assignments_sheet_widgets/assignments_action_buttons.dart';
import 'teacher_assignments_sheet_widgets/assignments_calendar_strip.dart';
import 'teacher_assignments_sheet_widgets/assignments_delete_dialog.dart';
import 'teacher_assignments_sheet_widgets/assignments_header.dart';
import 'teacher_assignments_sheet_widgets/assignments_list.dart';

class TeacherAssignmentsSheet extends StatefulWidget {
  final ClassInfo classInfo;
  final ClassCubit classCubit;
  final HomeCubit homeCubit;

  const TeacherAssignmentsSheet({
    super.key,
    required this.classInfo,
    required this.classCubit,
    required this.homeCubit,
  });

  @override
  State<TeacherAssignmentsSheet> createState() => _TeacherAssignmentsSheetState();
}

class _TeacherAssignmentsSheetState extends State<TeacherAssignmentsSheet> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> dates;

  @override
  void initState() {
    super.initState();
    // Create a list of dates for the horizontal calendar (7 days before to 14 days after today)
    dates = List.generate(22, (index) => DateTime.now().add(Duration(days: index - 7)));
    _fetchHomework(selectedDate);
  }

  void _fetchHomework(DateTime date) {
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    widget.classCubit.teacherHomeWork(
      code: int.tryParse(widget.classInfo.id) ?? 0,
      hwDate: formattedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                const AssignmentsHeader(),
                const SizedBox(height: 16),
                AssignmentsCalendarStrip(
                  dates: dates,
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    _fetchHomework(date);
                  },
                ),
                const SizedBox(height: 20),
                AssignmentsList(
                  scrollController: scrollController,
                  onEdit: (item) async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: widget.homeCubit,
                          child: CreateAssignmentScreen(homework: item),
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchHomework(selectedDate);
                    }
                  },
                  onDelete: (item) {
                    showDialog(
                      context: context,
                      builder: (context) => AssignmentsDeleteDialog(
                        item: item,
                        homeCubit: widget.homeCubit,
                        onSuccess: () => _fetchHomework(selectedDate),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AssignmentsActionButtons(
                  onCreate: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: widget.homeCubit,
                          child: const CreateAssignmentScreen(),
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchHomework(selectedDate);
                    }
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
