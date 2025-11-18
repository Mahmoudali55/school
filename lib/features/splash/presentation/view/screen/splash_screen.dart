import 'package:flutter/material.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) => NavigatorMethods.pushNamed(context, RoutesName.loginScreen),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
          style: AppTextStyle.text16MSecond(context),
        ),
      ),
    );
  }
}
