import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      final token = HiveMethods.getToken();
      if (token != null && token.isNotEmpty) {
        String type = HiveMethods.getType();
        String routeType = "admin";

        if (type == "1") {
          routeType = "student";
        } else if (type == "2") {
          routeType = "parent";
        } else if (type == "3") {
          routeType = "teacher";
        }

        NavigatorMethods.pushNamed(context, RoutesName.layoutScreen, arguments: routeType);
      } else {
        NavigatorMethods.pushNamed(context, RoutesName.onBoardingScreen);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(AppImages.schoolLoge, height: 300.h, width: 300.w)],
          ),
        ),
      ),
    );
  }
}
