import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalKay.dontHaveAccount.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.textSecondary(context)),
        ),
        TextButton(
          onPressed: () => NavigatorMethods.pushNamed(context, RoutesName.registerScreen),
          child: Text(
            AppLocalKay.register.tr(),
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
