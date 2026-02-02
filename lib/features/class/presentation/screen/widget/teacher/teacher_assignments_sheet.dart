import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/get_T_home_work_model.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/execution/create_assignment_screen.dart';

import 'homework_card.dart';

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
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildCalendarStrip(context),
                const SizedBox(height: 20),
                _buildHomeworkList(scrollController),
                const SizedBox(height: 12),
                _buildActionButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: const Icon(Icons.close, size: 18),
          ),
        ),
        const Spacer(),
        Text(AppLocalKay.tasks.tr(), style: AppTextStyle.titleLarge(context)),
        const Spacer(),
        const SizedBox(width: 32),
      ],
    );
  }

  Widget _buildCalendarStrip(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              _fetchHomework(date);
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', 'ar').format(date),
                    style: AppTextStyle.bodySmall(context).copyWith(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: AppTextStyle.titleMedium(context).copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeworkList(ScrollController scrollController) {
    return Expanded(
      child: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          final status = state.teacherHomeWorkStatus;

          if (status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (status.isFailure) {
            return Center(child: Text(status.error ?? 'حدث خطأ ما'));
          } else if (status.isSuccess) {
            final homeworkItems = status.data ?? [];
            if (homeworkItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalKay.no_task_today.tr(),
                      style: AppTextStyle.bodyLarge(context).copyWith(color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: homeworkItems.length,
              itemBuilder: (context, index) {
                final item = homeworkItems[index];
                return HomeworkCard(
                  item: item,
                  onEdit: () async {
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
                  onDelete: () =>
                      _showDeleteConfirmation(context, item, () => _fetchHomework(selectedDate)),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: () async {
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
            text: AppLocalKay.create_new_assignment.tr(),
            radius: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: AppLocalKay.cancel.tr(),
            radius: 12,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, THomeWorkItem item, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: widget.homeCubit,
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.deleteHomeworkStatus.isSuccess) {
              CommonMethods.showToast(message: state.deleteHomeworkStatus.data?.errorMsg ?? "");
              context.read<HomeCubit>().resetDeleteHomeworkStatus();
              Navigator.pop(context);
              onSuccess();
            } else if (state.deleteHomeworkStatus.isFailure) {
              CommonMethods.showToast(message: state.deleteHomeworkStatus.error ?? "");
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: Text(AppLocalKay.delete_task.tr(), style: AppTextStyle.titleLarge(context)),
              content: Text(
                AppLocalKay.delete_task_alert.tr(),
                style: AppTextStyle.bodyMedium(context),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalKay.cancel.tr()),
                ),
                state.addHomeworkStatus.isLoading
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () {
                          context.read<HomeCubit>().deleteHomework(classCode: item.classCode);
                        },
                        child: Text(
                          AppLocalKay.delete.tr(),
                          style: TextStyle(color: AppColor.errorColor(context)),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
