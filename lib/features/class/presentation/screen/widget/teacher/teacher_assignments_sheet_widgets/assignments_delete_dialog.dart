import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class AssignmentsDeleteDialog extends StatelessWidget {
  final dynamic item;
  final VoidCallback onSuccess;
  final HomeCubit homeCubit;

  const AssignmentsDeleteDialog({
    super.key,
    required this.item,
    required this.onSuccess,
    required this.homeCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
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
                        context.read<HomeCubit>().deleteHomework(
                          classCode: item.classCode,
                          HWDATE: item.hwDate,
                        );
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
    );
  }
}
