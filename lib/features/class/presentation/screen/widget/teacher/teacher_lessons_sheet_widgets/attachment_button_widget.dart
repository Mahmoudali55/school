import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/services/file_viewer_utils.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';

class AttachmentButton extends StatelessWidget {
  final String? lessonPath;

  const AttachmentButton({required this.lessonPath});

  @override
  Widget build(BuildContext context) {
    if (lessonPath == null || lessonPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () async {
        final cubit = context.read<ClassCubit>();

        await cubit.imageFileName(lessonPath!, context);
        final status = cubit.state.imageFileNameStatus;

        if (status?.isSuccess == true) {
          await FileViewerUtils.displayFile(context, status?.data ?? '', lessonPath!);
        } else if (status?.isFailure == true) {
          _showError(context, status?.error ?? '');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColor.primaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file_rounded, size: 16, color: AppColor.primaryColor(context)),
            Gap(4.w),
            context.watch<ClassCubit>().state.imageFileNameStatus?.isLoading == true
                ? CustomLoading(color: AppColor.whiteColor(context), size: 15.r)
                : Text(
                    AppLocalKay.attachments.tr(),
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.primaryColor(context)),
                  ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(msg)),
    );
  }
}
