import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomShimmerList extends StatelessWidget {
  const CustomShimmerList({
    super.key,
    this.width,
    this.height = 140,
    this.radius = 11,
    this.shimmerColor = Colors.white12,
    this.fillColor = const Color(0xFFEEEEEE),
    this.duration = const Duration(milliseconds: 1500),
    this.padding,
    this.length,
    this.margin,
  });

  final double? width;
  final double height;
  final double radius;
  final Color shimmerColor;
  final Color fillColor;
  final Duration duration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: _buildShimmerList()));
  }

  List<Widget> _buildShimmerList() {
    return List.generate(
      length ?? 5,
      (index) => Container(
        padding:
            padding ??
            const EdgeInsetsDirectional.only(start: 0, bottom: 0, end: 0),
        width: width ?? double.infinity,
        margin: margin ?? const EdgeInsetsDirectional.only(bottom: 16),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: Shimmer(
          color: shimmerColor,
          duration: duration,
          child: Container(
            color: fillColor,
            height: height,
            width: width ?? double.infinity,
          ),
        ),
      ),
    );
  }
}
