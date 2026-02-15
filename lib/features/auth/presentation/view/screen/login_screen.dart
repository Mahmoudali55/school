import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';
import 'package:my_template/features/auth/presentation/view/screen/widgets/login_form.dart';
import 'package:my_template/features/auth/presentation/view/screen/widgets/login_header.dart';
import 'package:my_template/features/auth/presentation/view/screen/widgets/sign_up_link.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.login.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                NavigatorMethods.pushNamed(
                  context,
                  RoutesName.layoutScreen,
                  arguments: context.read<AuthCubit>().getRouteType(),
                );
              }
              if (state.loginStatus.isFailure) {
                CommonMethods.showToast(
                  message: state.loginStatus.error ?? "Login failed",
                  type: ToastType.error,
                );
              }
            },
            child: const Column(children: [LoginHeader(), LoginForm(), SignUpLink()]),
          ),
        ),
      ),
    );
  }
}
