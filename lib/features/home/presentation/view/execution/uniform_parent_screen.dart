import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/add_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/uniform_bottom_sheet_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/uniform_card_widget.dart';
import '../../../../../core/utils/app_local_kay.dart';

class UniformParentScreen extends StatefulWidget {
  const UniformParentScreen({super.key});

  @override
  State<UniformParentScreen> createState() => _UniformParentScreenState();
}

class _UniformParentScreenState extends State<UniformParentScreen> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _noteController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _sizeList = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  late String _currentSelectedSize;
  String? _currentSelectedStudentId;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _noteController = TextEditingController();
    _currentSelectedSize = _sizeList[1];

    final cubit = context.read<HomeCubit>();
    cubit.getUniform(code: int.parse(HiveMethods.getUserCode()));

    if (cubit.state.parentsStudentStatus.data == null) {
      cubit.parentData(int.parse(HiveMethods.getUserCode()));
    } else {
      final students = cubit.state.parentsStudentStatus.data!;
      if (students.isNotEmpty) {
        _currentSelectedStudentId = students[0].studentCode.toString();
      }
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _resetFormFields() {
    _heightController.clear();
    _weightController.clear();
    _noteController.clear();
    _currentSelectedSize = _sizeList[1];
  }
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        final isAddOk = state.addUniformStatus.isSuccess;
        final isEditOk = state.editUniformStatus.isSuccess;
        final isFail =
            state.addUniformStatus.isFailure || state.editUniformStatus.isFailure;

        if (!isAddOk && !isEditOk && !isFail) return;

        final message = isAddOk
            ? state.addUniformStatus.data?.msg
            : isEditOk
                ? state.editUniformStatus.data?.msg
                : state.addUniformStatus.isFailure
                    ? state.addUniformStatus.error
                    : state.editUniformStatus.error;

        CommonMethods.showToast(
          message: message ?? '',
          type: (isAddOk || isEditOk) ? ToastType.success : ToastType.error,
        );

        if (isAddOk || isEditOk) {
          if (isAddOk) homeCubit.resetAddUniformStatus();
          if (isEditOk) homeCubit.resetEditUniformStatus();
          homeCubit.getUniform(code: int.parse(HiveMethods.getUserCode()));
          _resetFormFields();
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: CustomAppBar(
          context,
          title: Text(
            AppLocalKay.school_uniform.tr(),
            style: AppTextStyle.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openBottomSheet(context, cubit: homeCubit),
          backgroundColor: AppColor.infoColor(context),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon:  Icon(Icons.add_rounded, color: AppColor.whiteColor(context)),
          label: Text(
            AppLocalKay.add.tr(),
            style:  TextStyle(
              color:  AppColor.whiteColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.getUniformsStatus.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.infoColor(context),
                ),
              );
            }

            final uniforms = state.getUniformsStatus.data?.data ?? [];
            if (uniforms.isEmpty) return _buildEmptyState(context);

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 100.h),
              itemCount: uniforms.length,
              separatorBuilder: (_, __) => Gap(12.h),
              itemBuilder: (ctx, index) {
                final item = uniforms[index];
                return UniformCard(
                  item: item,
                  onEdit: () {
                    _heightController.text = item.height.toString();
                    _weightController.text = item.weight.toString();
                    _noteController.text = item.notes;
                    _currentSelectedSize = item.size;
                    _currentSelectedStudentId = item.studentCode;
                    _openBottomSheet(context, cubit: homeCubit, item: item);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColor.infoColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 44,
              color: AppColor.infoColor(context),
            ),
          ),
          const Gap(20),
          Text(
            AppLocalKay.no_uniform_requests.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  void _openBottomSheet(
    BuildContext context, {
    required HomeCubit cubit,
    UniformItem? item,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogCtx) => BlocProvider.value(
        value: cubit,
        child: UniformBottomSheet(
          formKey: _formKey,
          heightController: _heightController,
          weightController: _weightController,
          noteController: _noteController,
          sizeList: _sizeList,
          currentSize: _currentSelectedSize,
          currentStudentId: _currentSelectedStudentId,
          item: item,
          onSizeChanged: (v) => setState(() => _currentSelectedSize = v),
          onStudentChanged: (v) =>
              setState(() => _currentSelectedStudentId = v),
          onSubmit: (cubitState) {
            if (!_formKey.currentState!.validate()) return;
            if (_currentSelectedStudentId == null) {
              CommonMethods.showToast(
                message: AppLocalKay.select_student.tr(),
                type: ToastType.error,
              );
              return;
            }

            if (item != null) {
              cubit.editUniform(
                EditUniformRequestModel(
                  id: item.id,
                  studentCode: int.parse(_currentSelectedStudentId!),
                  parentCode: int.parse(HiveMethods.getUserCode()),
                  height: int.parse(_heightController.text),
                  weight: double.parse(_weightController.text),
                  size: _currentSelectedSize,
                  notes: _noteController.text,
                ),
              );
            } else {
              cubit.addUniform(
                AddUniformRequestModel(
                  studentCode: int.parse(_currentSelectedStudentId!),
                  parentCode: int.parse(HiveMethods.getUserCode()),
                  height: int.parse(_heightController.text),
                  weight: int.parse(_weightController.text),
                  size: _currentSelectedSize,
                  notes: _noteController.text,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}





