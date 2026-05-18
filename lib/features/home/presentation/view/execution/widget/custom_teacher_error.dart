import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

class CustomTeacherError extends StatelessWidget {
  const CustomTeacherError({
    super.key,
    required this.status,
    required String searchQuery,
  }) : _searchQuery = searchQuery;

  final StatusState<List<TeacherDataModel>>? status;
  final String _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 56.r, color: Colors.red.shade300),
          Gap(12.h),
          Text(
            status!.error ?? 'حدث خطأ',
            style: AppTextStyle.bodyMedium(context)
                .copyWith(color: AppColor.textColor(context).withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
          Gap(20.h),
          TextButton.icon(
            onPressed: () => context
                .read<HomeCubit>()
                .teacherData(searchVal: _searchQuery),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          )
        ],
      ),
    );
  }
}


