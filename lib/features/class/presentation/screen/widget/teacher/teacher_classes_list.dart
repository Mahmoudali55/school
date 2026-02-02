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

import 'teacher_class_card.dart';

class TeacherClassesList extends StatelessWidget {
  final List<ClassInfo> classes;

  const TeacherClassesList({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalKay.empty_classes.tr(),
              style: AppTextStyle.titleMedium(context, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(AppLocalKay.empty_classes_hint.tr(), style: AppTextStyle.bodyMedium(context)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        return TeacherClassCard(
          classInfo: classInfo,
          onStudentsPressed: () => _showStudentsSheet(context, classInfo),
          onAssignmentsPressed: () => _showAssignmentsSheet(context, classInfo),
          onAttendancePressed: () => _showAttendanceSheet(context, classInfo),
        );
      },
    );
  }

  void _showStudentsSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Center(child: Icon(Icons.close, color: Colors.black, size: 18)),
                    ),
                  ),
                  const Spacer(),
                  Text('${AppLocalKay.students.tr()} ', style: AppTextStyle.titleLarge(context)),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: classInfo.studentCount.clamp(0, 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text('${index + 1}'),
                      ),
                      title: Text('${AppLocalKay.student.tr()} '),
                      subtitle: const Text('درجة الحضور: 95%'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAssignmentsSheet(BuildContext context, ClassInfo classInfo) {
    final classCubit = context.read<ClassCubit>();
    final homeCubit = context.read<HomeCubit>();
    DateTime selectedDate = DateTime.now();

    // Create a list of dates for the horizontal calendar (7 days before to 14 days after today)
    final List<DateTime> dates = List.generate(
      22,
      (index) => DateTime.now().add(Duration(days: index - 7)),
    );

    void fetchHomework(DateTime date) {
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      classCubit.teacherHomeWork(code: int.tryParse(classInfo.id) ?? 0, hwDate: formattedDate);
    }

    // Initial fetch
    fetchHomework(selectedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: classCubit),
            BlocProvider.value(value: homeCubit),
          ],
          child: StatefulBuilder(
            builder: (context, setState) {
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
                          // Header
                          Row(
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
                          ),
                          const SizedBox(height: 16),

                          // Horizontal Calendar Strip
                          SizedBox(
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
                                    fetchHomework(date);
                                  },
                                  child: Container(
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.blue : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey[300]!,
                                      ),
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
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
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
                          ),
                          const SizedBox(height: 20),

                          // Homework List
                          Expanded(
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
                                          Icon(
                                            Icons.assignment_outlined,
                                            size: 60,
                                            color: Colors.grey[300],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            AppLocalKay.no_task_today.tr(),
                                            style: AppTextStyle.bodyLarge(
                                              context,
                                            ).copyWith(color: Colors.grey[400]),
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
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        elevation: 0,
                                        color: Colors.grey[50],
                                        borderOnForeground: true,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                      item.courseName,
                                                      style: AppTextStyle.bodySmall(context)
                                                          .copyWith(
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        visualDensity: VisualDensity.compact,
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.blue,
                                                          size: 20,
                                                        ),
                                                        onPressed: () async {
                                                          final result = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BlocProvider.value(
                                                                    value: homeCubit,
                                                                    child: CreateAssignmentScreen(
                                                                      homework: item,
                                                                    ),
                                                                  ),
                                                            ),
                                                          );
                                                          if (result == true) {
                                                            fetchHomework(selectedDate);
                                                          }
                                                        },
                                                      ),
                                                      IconButton(
                                                        visualDensity: VisualDensity.compact,
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                        onPressed: () => _showDeleteConfirmation(
                                                          context,
                                                          item,
                                                          () => fetchHomework(selectedDate),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                item.hw,
                                                style: AppTextStyle.titleMedium(
                                                  context,
                                                ).copyWith(fontWeight: FontWeight.w600),
                                              ),
                                              if (item.notes.isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${AppLocalKay.note.tr()}: ${item.notes}',
                                                  style: AppTextStyle.bodyMedium(
                                                    context,
                                                  ).copyWith(color: Colors.grey[600]),
                                                ),
                                              ],
                                              const SizedBox(height: 8),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  item.hwDate,
                                                  style: AppTextStyle.bodySmall(
                                                    context,
                                                  ).copyWith(color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider.value(
                                          value: homeCubit,
                                          child: const CreateAssignmentScreen(),
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      fetchHomework(selectedDate);
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, THomeWorkItem item, VoidCallback onSuccess) {
    final homeCubit = context.read<HomeCubit>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: homeCubit,
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

  void _showAttendanceSheet(BuildContext context, ClassInfo classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('حضور ${classInfo.className}', style: AppTextStyle.titleLarge(context)),
              const SizedBox(height: 16),
              const Text('نسبة الحضور الحالية: 92%'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('تسجيل الحضور اليوم'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('عرض سجل الحضور'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
            ],
          ),
        );
      },
    );
  }
}
