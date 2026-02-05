import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class FileViewerUtils {
  static Future<void> displayFile(
    BuildContext context,
    String base64String,
    String fileName,
  ) async {
    if (base64String.isEmpty) return;

    try {
      final bool isImage = _isImage(fileName);

      if (isImage) {
        _showImageDialog(context, base64String, fileName);
      } else {
        await _openExternalFile(base64String, fileName);
      }
    } catch (e) {
      debugPrint('Error displaying file: $e');
    }
  }

  static bool _isImage(String fileName) {
    final List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final String lowerFileName = fileName.toLowerCase();
    return imageExtensions.any((ext) => lowerFileName.endsWith(ext));
  }

  static void _showImageDialog(BuildContext context, String base64String, String fileName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      fileName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () => _openExternalFile(base64String, fileName),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PhotoView(
                      imageProvider: MemoryImage(base64Decode(base64String)),
                      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openExternalFile(String base64String, String fileName) async {
    try {
      final bytes = base64Decode(base64String);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      await OpenFilex.open(file.path);
    } catch (e) {
      debugPrint('Error opening external file: $e');
    }
  }
}
