import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.width,
    this.height = 25,
    this.radius = 10,
    this.shimmerColor = Colors.white12,
    this.fillColor = const Color(0xFFEEEEEE),
    this.duration = const Duration(milliseconds: 1500),
  });

  final double? width;
  final double height;
  final double radius;
  final Color shimmerColor;
  final Color fillColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Shimmer(
        color: shimmerColor,
        duration: duration,
        child: Container(
          color: fillColor,
          height: height,
          width: width ?? double.infinity,
        ),
      ),
    );
  }
}
