import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';
import 'package:my_template/features/profile/presentation/screen/widget/parent_profile/parent_info_section_widget.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.profile == null) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          final parentInfo = [
            {'label': 'الاسم', 'value': state.profile!.name, 'icon': Icons.person},
            {'label': 'البريد', 'value': state.profile!.email, 'icon': Icons.email},
            {'label': 'الهاتف', 'value': state.profile!.phone ?? '', 'icon': Icons.phone},
            {'label': 'العنوان', 'value': state.profile!.address ?? '', 'icon': Icons.location_on},
            {'label': 'الهوية', 'value': state.profile!.idNumber ?? '', 'icon': Icons.badge},
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
