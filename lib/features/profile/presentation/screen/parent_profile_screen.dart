import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';
import 'package:my_template/features/profile/presentation/screen/widget/parent_profile/parent_info_section_widget.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadParentProfile(int.parse(HiveMethods.getUserCode()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.setting_profile.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.parentProfileStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.parentProfileStatus.isFailure) {
            return Center(child: Text(state.error!));
          }
          if (state.parentProfileStatus.data == null) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          final parentData = state.parentProfileStatus.data;
          final parentInfo = [
            {
              'label': AppLocalKay.parent_name.tr(),
              'value': parentData?.parentNameAr ?? '',
              'icon': Icons.person,
            },
            {
              'label': AppLocalKay.parent_name_en.tr(),
              'value': parentData?.parentNameEng ?? '',
              'icon': Icons.person,
            },
            {
              'label': AppLocalKay.email.tr(),
              'value': parentData?.email ?? '',
              'icon': Icons.email,
            },
            {
              'label': AppLocalKay.mobile_no.tr(),
              'value': parentData?.mobileNo ?? '',
              'icon': Icons.phone,
            },
            {
              'label': AppLocalKay.id_number.tr(),
              'value': parentData?.idNo ?? '',
              'icon': Icons.badge,
            },
            {
              'label': AppLocalKay.account_no.tr(),
              'value': parentData?.accountNo?.toString() ?? '',
              'icon': Icons.account_balance,
            },
            {
              'label': AppLocalKay.employee_children.tr(),
              'value': parentData?.employeeChildren?.toString() ?? '',
              'icon': Icons.group,
            },
            {
              'label': AppLocalKay.nation_code.tr(),
              'value': parentData?.nationCode?.toString() ?? '',
              'icon': Icons.flag,
            },
            {
              'label': AppLocalKay.priority_name.tr(),
              'value': parentData?.priorityName ?? '',
              'icon': Icons.priority_high,
            },
            {
              'label': AppLocalKay.authorized_name.tr(),
              'value': parentData?.authName ?? '',
              'icon': Icons.business,
            },
            {
              'label': AppLocalKay.password.tr(),
              'value': parentData?.password ?? '',
              'icon': Icons.lock,
            },
          ];

          return SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                ParentInfoSection(infoData: parentInfo),
                32.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
