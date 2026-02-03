import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';

class StudentsListSheet extends StatelessWidget {
  const StudentsListSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                      const Spacer(),
                      Text(AppLocalKay.students.tr(), style: AppTextStyle.titleLarge(context)),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.studentClassesStatus.isLoading) {
                          return const Center(child: CustomLoading());
                        }

                        if (state.studentClassesStatus.isFailure) {
                          return Center(
                            child: Text(
                              state.studentClassesStatus.error ?? '',
                              style: AppTextStyle.bodyMedium(
                                context,
                              ).copyWith(color: AppColor.errorColor(context)),
                            ),
                          );
                        }

                        final students = state.studentClassesStatus.data?.students ?? [];

                        if (students.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalKay.no_students.tr(),
                              style: AppTextStyle.bodyMedium(context),
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: students.length,
                          separatorBuilder: (_, __) => const Divider(height: 8),
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.primaryColor(
                                  context,
                                ).withValues(alpha: (0.1)),
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                student.studentName,
                                style: AppTextStyle.bodyMedium(context),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
