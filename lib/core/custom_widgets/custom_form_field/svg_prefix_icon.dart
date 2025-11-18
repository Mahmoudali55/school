import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgPrefixIcon extends StatelessWidget {
  final String imagePath;
  final Color? color;
  final double width;
  final double height;
  const SvgPrefixIcon({
    super.key,
    required this.imagePath,
    this.color,
    this.width = 25,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                )
              : null,
        ),
      ),
    );
  }
}
