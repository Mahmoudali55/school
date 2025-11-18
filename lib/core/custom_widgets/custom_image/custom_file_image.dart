import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/navigator_methods.dart';
import '../zoom_image/zoom_image_screen.dart';

class CustomFileImage extends StatelessWidget {
  final File? imageFile;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit? fit;
  final bool hasZoom;
  final BorderRadius? borderRadius;

  const CustomFileImage({
    super.key,
    required this.imageFile,
    this.width,
    this.height,
    this.fit,
    this.radius = 0,
    this.hasZoom = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasZoom && imageFile != null
          ? () {
              NavigatorMethods.pushNamed(
                context,
                ZoomImageScreen.routeName,
                arguments: ZoomImageArgs(imageFile: imageFile),
              );
            }
          : null,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child: imageFile != null
            ? Image(
                image: FileImage(imageFile!),
                fit: fit,
                width: width,
                height: height,
                errorBuilder: (context, url, error) => SizedBox(
                  width: width,
                  height: height,
                ),
              )
            : SizedBox(
                width: width,
                height: height,
              ),
      ),
    );
  }
}
