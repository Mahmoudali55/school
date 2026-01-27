import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/add_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

import '../../../../../core/utils/app_local_kay.dart';

class UniformParentScreen extends StatefulWidget {
  const UniformParentScreen({super.key});

  @override
  State<UniformParentScreen> createState() => _UniformParentScreenState();
}

class _UniformParentScreenState extends State<UniformParentScreen> {
  // Move all controllers and keys to the State class to prevent them
  // from being recreated and causing the keyboard to disappear.
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController noteController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final sizeList = ["S", "M", "L", "XL", "XXL", "XXXL"];
  late String currentSelectedSize;
  String? currentSelectedStudentId;

  @override
  void initState() {
    super.initState();
    heightController = TextEditingController();
    weightController = TextEditingController();
    noteController = TextEditingController();
    currentSelectedSize = sizeList[1];
    final homeCubit = context.read<HomeCubit>();
    homeCubit.getUniform(code: int.parse(HiveMethods.getUserCode()));
    if (homeCubit.state.parentsStudentStatus.data == null) {
      homeCubit.parentData(int.parse(HiveMethods.getUserCode()));
    } else {
      final students = homeCubit.state.parentsStudentStatus.data!;
      if (students.isNotEmpty) {
        currentSelectedStudentId = students[0].studentCode.toString();
      }
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        final isAddSuccess = state.addUniformStatus.isSuccess;
        final isEditSuccess = state.editUniformStatus.isSuccess;
        final isFailure = state.addUniformStatus.isFailure || state.editUniformStatus.isFailure;

        if (isAddSuccess || isEditSuccess || isFailure) {
          final message = isAddSuccess
              ? state.addUniformStatus.data?.msg
              : isEditSuccess
              ? state.editUniformStatus.data?.msg
              : state.addUniformStatus.isFailure
              ? state.addUniformStatus.error
              : state.editUniformStatus.error;

          CommonMethods.showToast(
            message: message ?? "",
            type: (isAddSuccess || isEditSuccess) ? ToastType.success : ToastType.error,
          );

          if (isAddSuccess || isEditSuccess) {
            if (isAddSuccess) homeCubit.resetAddUniformStatus();
            if (isEditSuccess) homeCubit.resetEditUniformStatus();
            homeCubit.getUniform(code: int.parse(HiveMethods.getUserCode()));
            heightController.clear();
            weightController.clear();
            noteController.clear();
            currentSelectedSize = sizeList[1];
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (dialogContext) =>
                  BlocProvider.value(value: homeCubit, child: _buildSizeInputSection(context)),
            );
          },
          label: Text(AppLocalKay.add.tr()),
          backgroundColor: AppColor.infoColor(context),
        ),
        appBar: CustomAppBar(
          context,
          title: Text(AppLocalKay.school_uniform.tr()),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.getUniformsStatus.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final uniforms = state.getUniformsStatus.data?.data ?? [];

            if (uniforms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
                    const Gap(16),
                    Text(
                      AppLocalKay.no_uniform_requests.tr(),
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: uniforms.length,
              itemBuilder: (context, index) {
                final item = uniforms[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.w),
                    leading: CircleAvatar(
                      backgroundColor: AppColor.primaryColor(context).withOpacity(0.1),
                      child: Icon(Icons.person, color: AppColor.primaryColor(context)),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.studentName,
                            style: AppTextStyle.bodyLarge(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            heightController.text = item.height.toString();
                            weightController.text = item.weight.toString();
                            noteController.text = item.notes;
                            currentSelectedSize = item.size;
                            currentSelectedStudentId = item.studentCode;

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (dialogContext) => BlocProvider.value(
                                value: homeCubit,
                                child: _buildSizeInputSection(context, item: item),
                              ),
                            ).then((_) {
                              // Reset controllers when bottom sheet closed manually if needed
                            });
                          },
                          icon: Icon(Icons.edit, color: AppColor.primaryColor(context), size: 20.w),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(4),
                        Text(
                          "${AppLocalKay.height.tr()}: ${item.height} cm | ${AppLocalKay.weight.tr()}: ${item.weight} kg",
                        ),
                        Text("${AppLocalKay.typical_size.tr()}: ${item.size}"),
                        if (item.notes.isNotEmpty)
                          Text(
                            "${AppLocalKay.note.tr()}: ${item.notes}",
                            style: AppTextStyle.bodySmall(context),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSizeInputSection(BuildContext context, {UniformItem? item}) {
    final homeCubit = context.read<HomeCubit>();
    final isEdit = item != null;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        final initialStudents = homeCubit.state.parentsStudentStatus.data ?? [];
        if (currentSelectedStudentId == null && initialStudents.isNotEmpty) {
          currentSelectedStudentId = initialStudents[0].studentCode.toString();
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),

                  // Title
                  Row(
                    children: [
                      Icon(
                        isEdit ? Icons.edit : Icons.straighten,
                        color: AppColor.primaryColor(context),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isEdit ? AppLocalKay.edit.tr() : AppLocalKay.student_sizes.tr(),
                        style: AppTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Gap(8),
                  Text(
                    AppLocalKay.measurements_hint.tr(),
                    style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
                  ),

                  const Gap(16),
                  Text(
                    AppLocalKay.select_student.tr(),
                    style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),

                  // Dropdown for students
                  if (initialStudents.isEmpty)
                    Text(
                      "Loading students...",
                      style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(14.r),
                        color: Colors.grey[50],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentSelectedStudentId,
                          isExpanded: true,
                          disabledHint: isEdit ? Text(item.studentName) : null,
                          items: initialStudents.map((student) {
                            return DropdownMenuItem<String>(
                              value: student.studentCode.toString(),
                              child: Text(student.studentName),
                            );
                          }).toList(),
                          onChanged: isEdit
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setDialogState(() => currentSelectedStudentId = value);
                                  }
                                },
                        ),
                      ),
                    ),

                  const Gap(16),
                  // Height
                  CustomFormField(
                    controller: heightController,
                    title: AppLocalKay.height.tr(),
                    prefixIcon: const Icon(Icons.height),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalKay.please_enter_height.tr();
                      }
                      return null;
                    },
                  ),
                  const Gap(12),

                  // Weight
                  CustomFormField(
                    controller: weightController,
                    title: AppLocalKay.weight.tr(),
                    prefixIcon: const Icon(Icons.monitor_weight),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalKay.please_enter_weight.tr();
                      }
                      return null;
                    },
                  ),
                  const Gap(12),

                  // Size selection
                  Text(
                    AppLocalKay.typical_size.tr(),
                    style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(14.r),
                      color: Colors.grey[50],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentSelectedSize,
                        isExpanded: true,
                        items: sizeList.map((size) {
                          return DropdownMenuItem<String>(value: size, child: Text(size));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => currentSelectedSize = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const Gap(12),

                  // Notes
                  CustomFormField(
                    controller: noteController,
                    title: AppLocalKay.note.tr(),
                    prefixIcon: const Icon(Icons.edit_note),
                  ),
                  const Gap(24),

                  // Save / Edit Button
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return CustomButton(
                        radius: 14.r,
                        cubitState: isEdit ? state.editUniformStatus : state.addUniformStatus,
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              currentSelectedStudentId != null) {
                            if (isEdit) {
                              homeCubit.editUniform(
                                EditUniformRequestModel(
                                  id: item.id,
                                  studentCode: int.parse(currentSelectedStudentId!),
                                  parentCode: int.parse(HiveMethods.getUserCode()),
                                  height: int.parse(heightController.text),
                                  weight: double.parse(weightController.text),
                                  size: currentSelectedSize,
                                  notes: noteController.text,
                                ),
                              );
                            } else {
                              homeCubit.addUniform(
                                AddUniformRequestModel(
                                  studentCode: int.parse(currentSelectedStudentId!),
                                  parentCode: int.parse(HiveMethods.getUserCode()),
                                  height: int.parse(heightController.text),
                                  weight: int.parse(weightController.text),
                                  size: currentSelectedSize,
                                  notes: noteController.text,
                                ),
                              );
                            }
                          } else if (currentSelectedStudentId == null) {
                            CommonMethods.showToast(
                              message: AppLocalKay.select_student.tr(),
                              type: ToastType.error,
                            );
                          }
                        },
                        text: isEdit ? AppLocalKay.edit.tr() : AppLocalKay.save.tr(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
