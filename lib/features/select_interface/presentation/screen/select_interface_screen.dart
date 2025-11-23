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

class SelectInterfaceScreen extends StatelessWidget {
  const SelectInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        centerTitle: true,
        title: Text(AppLocalKay.selectUserType.tr(), style: AppTextStyle.appBarStyle(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(AppImages.schoolloge, height: 70.h, width: 70.w),
              Gap(50.h),
              Expanded(
                child: BlocBuilder<InterfaceCubit, InterfaceState>(
                  builder: (context, state) {
                    final cubit = context.read<InterfaceCubit>();
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.2,
                      children: cubit.userTypes.map((user) {
                        bool isSelected = state.selectedUser == user;

                        IconData iconData;
                        switch (user.icon) {
                          case 'school':
                            iconData = Icons.school;
                            break;
                          case 'family_restroom':
                            iconData = Icons.family_restroom;
                            break;
                          case 'person':
                            iconData = Icons.person;
                            break;
                          case 'apartment':
                            iconData = Icons.apartment;
                            break;
                          default:
                            iconData = Icons.person;
                            break;
                        }

                        return GestureDetector(
                          onTap: () => cubit.selectUser(user),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.primaryColor(context).withAlpha(190)
                                  : AppColor.primaryColor(context).withAlpha(120),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.blackColor(context)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.shadowColor(context),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(iconData, size: 50, color: AppColor.whiteColor(context)),
                                const SizedBox(height: 10),
                                Text(
                                  user.title,
                                  style: AppTextStyle.headlineSmall(
                                    context,
                                    color: AppColor.whiteColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Gap(20.h),
              CustomButton(
                radius: 12,
                child: Text(AppLocalKay.continues.tr(), style: AppTextStyle.buttonStyle(context)),
                onPressed: () {
                  final selectedUser = context.read<InterfaceCubit>().state.selectedUser;
                  if (selectedUser != null) {
                    NavigatorMethods.pushNamed(
                      context,
                      RoutesName.loginScreen,
                      arguments: selectedUser,
                    );
                  } else {
                    CommonMethods.showToast(
                      message: AppLocalKay.selectUser.tr(),
                      type: ToastType.error,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
