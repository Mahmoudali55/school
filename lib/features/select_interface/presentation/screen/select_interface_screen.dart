import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/select_interface/presentation/cubit/select_interface_cubit.dart';
import 'package:my_template/features/select_interface/presentation/cubit/select_interface_state.dart';
import 'package:my_template/features/select_interface/presentation/screen/widget/Interface_card_widget.dart';

class SelectInterfaceScreen extends StatelessWidget {
  const SelectInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        centerTitle: true,
        elevation: 0,
        title: Text(AppLocalKay.selectUserType.tr(), style: AppTextStyle.appBarStyle(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(AppImages.schoolLoge, height: 80.h),
                ),
              ),

              Gap(35.h),

              Expanded(
                child: BlocBuilder<InterfaceCubit, InterfaceState>(
                  builder: (context, state) {
                    final cubit = context.read<InterfaceCubit>();

                    return GridView.builder(
                      itemCount: cubit.userTypes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 18.h,
                        crossAxisSpacing: 18.w,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (_, index) {
                        final user = cubit.userTypes[index];
                        final isSelected = state.selectedUser == user;

                        IconData icon = Icons.person;
                        switch (user.icon) {
                          case 'family_restroom':
                            icon = Icons.family_restroom;
                            break;
                          case 'school':
                            icon = Icons.school;
                            break;
                          case 'apartment':
                            icon = Icons.apartment;
                            break;
                        }

                        return InterfaceCard(
                          title: user.title,
                          icon: icon,
                          isSelected: isSelected,
                          onTap: () => cubit.selectUser(user),
                        );
                      },
                    );
                  },
                ),
              ),
              Gap(18.h),
              CustomButton(
                radius: 12,
                child: Text(AppLocalKay.continues.tr(), style: AppTextStyle.buttonStyle(context)),
                onPressed: () {
                  final selectedUser = context.read<InterfaceCubit>().state.selectedUser;
                  if (selectedUser == null) {
                    CommonMethods.showToast(
                      message: AppLocalKay.selectUser.tr(),
                      type: ToastType.error,
                    );
                    return;
                  }
                  NavigatorMethods.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.loginScreen,
                    arguments: selectedUser,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
