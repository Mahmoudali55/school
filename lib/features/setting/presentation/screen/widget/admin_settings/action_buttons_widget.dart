import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.logoutStatus.isSuccess) {
          CommonMethods.showToast(message: AppLocalKay.sign_out.tr(), type: ToastType.success);
          NavigatorMethods.pushNamed(context, RoutesName.loginScreen);
        }
        if (state.changePasswordStatus.isFailure) {
          CommonMethods.showToast(
            message: state.changePasswordStatus.error ?? '',
            type: ToastType.error,
          );
        }
      },
      child: Column(
        children: [
          CustomButton(
            radius: 12.r,
            width: double.infinity,
            color: AppColor.errorColor(context),
            onPressed: () => logout(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppColor.whiteColor(context)),
                SizedBox(width: 10.w),
                context.watch<SettingsCubit>().state.logoutStatus.isLoading
                    ? CustomLoading(color: AppColor.whiteColor(context), size: 20)
                    : Text(
                        AppLocalKay.logout.tr(),
                        style: AppTextStyle.bodyLarge(context, color: AppColor.whiteColor(context)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

logout(BuildContext context) {
  try {
    final settingsCubit = context.read<SettingsCubit>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: settingsCubit,
          child: AlertDialog(
            title: Text(
              AppLocalKay.logout.tr(),
              style: AppTextStyle.bodyMedium(
                dialogContext,
                color: AppColor.errorColor(dialogContext),
              ),
            ),
            content: Text(
              AppLocalKay.are_you_sure.tr(),
              style: AppTextStyle.bodyLarge(dialogContext),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(AppLocalKay.cancel.tr(), style: AppTextStyle.bodyLarge(dialogContext)),
              ),
              TextButton(
                onPressed: () {
                  settingsCubit.logout();
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  AppLocalKay.logout.tr(),
                  style: AppTextStyle.bodyMedium(
                    dialogContext,
                    color: AppColor.errorColor(dialogContext),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  } catch (e) {}
}
