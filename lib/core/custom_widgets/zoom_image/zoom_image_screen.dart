import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../custom_app_bar/custom_app_bar.dart';
import '../custom_loading/custom_loading.dart';

class ZoomImageArgs {
  final String? imageUrl;
  final File? imageFile;

  const ZoomImageArgs({
    this.imageUrl,
    this.imageFile,
  });
}

class ZoomImageScreen extends StatefulWidget {
  final ZoomImageArgs args;
  const ZoomImageScreen({
    super.key,
    required this.args,
  });

  static const String routeName = 'ZoomImageScreen';

  @override
  State<ZoomImageScreen> createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: PhotoView(
        imageProvider: _imageProvider(),
        loadingBuilder: (context, event) {
          return const Center(
            child: CustomLoading(),
          );
        },
        // errorBuilder: (context, error, stackTrace) {
        //   return const Center(
        //     child: Image(
        //       image: AssetImage(AppImages.splashImage),
        //     ),
        //   );
        // },
      ),
    );
  }

  ImageProvider? _imageProvider() {
    if (widget.args.imageUrl != null) {
      return NetworkImage(widget.args.imageUrl!);
    } else if (widget.args.imageFile != null) {
      return FileImage(widget.args.imageFile!);
    }
    return null;
  }
}
