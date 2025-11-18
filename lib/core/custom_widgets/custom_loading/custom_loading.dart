import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final double size;
  final Color? color;
  const CustomLoading({super.key, this.size = 35, this.color});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.discreteCircle(
      color: color ?? AppColor.primaryColor(context),
      secondRingColor: color ?? AppColor.primaryColor(context),
      thirdRingColor: color ?? AppColor.primaryColor(context),
      size: size,
    );
  }
}
