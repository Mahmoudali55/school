import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';

import 'homework_card.dart';

class AssignmentsList extends StatelessWidget {
  final ScrollController scrollController;
  final Function(dynamic item) onEdit;
  final Function(dynamic item) onDelete;

  const AssignmentsList({
    super.key,
    required this.scrollController,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                    Icon(
                      Icons.assignment_outlined,
                      size: 60,
                      color: AppColor.grey300Color(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalKay.no_task_today.tr(),
                      style: AppTextStyle.bodyLarge(
                        context,
                      ).copyWith(color: AppColor.grey400Color(context)),
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
                  onEdit: () => onEdit(item),
                  onDelete: () => onDelete(item),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
