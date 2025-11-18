import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/network/status.state.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_style.dart';

class CustomButton extends StatelessWidget {
  final double radius;
  final double? width;
  final double height;
  final TextStyle? style;
  final String? text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final StatusState? cubitState;
  final bool isLoading;
  final bool isMainColor;
  final bool hasShadow;
  final void Function()? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    this.radius = 50,
    this.width,
    this.height = 47,
    this.style,
    this.text,
    this.prefixIcon = const SizedBox(),
    this.suffixIcon = const SizedBox(),
    this.color,
    this.gradient,
    this.cubitState,
    this.isLoading = false,
    this.isMainColor = true,
    this.hasShadow = false,
    this.onPressed,
    this.child,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color:
              color ??
              (isMainColor
                  ? AppColor.primaryColor(context)
                  : AppColor.secondAppColor(context)),
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: cubitState?.isLoading == true ? null : onPressed,
            child: Center(
              child: cubitState?.isLoading == true
                  ? CupertinoActivityIndicator(
                      color: AppColor.whiteColor(context),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (prefixIcon != null) ...{
                          prefixIcon!,
                          const SizedBox(width: 5),
                        },
                        Flexible(
                          child:
                              child ??
                              Text(
                                text ?? "",
                                textAlign: TextAlign.center,
                                style:
                                    style ?? AppTextStyle.buttonStyle(context),
                              ),
                        ),
                        if (suffixIcon != null) ...{
                          const SizedBox(width: 5),
                          suffixIcon!,
                        },
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
